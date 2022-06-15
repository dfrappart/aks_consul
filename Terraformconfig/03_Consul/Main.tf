######################################################################
# Webshop K8S + Storage resources
######################################################################

######################################################################
# Access to terraform
######################################################################

terraform {

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id         = var.AzureSubscriptionID
  client_id               = var.AzureClientID
  client_secret           = var.AzureClientSecret
  tenant_id               = var.AzureTenantID

  features {
    resource_group {
    
      prevent_deletion_if_contains_resources = false
    
    }
  }
}

provider "kubernetes" {

  host                    = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.host #module.AKSClus.KubeAdminCFG_HostName
  username                = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.username
  password                = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.password
  client_certificate      = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.client_certificate)
  client_key              = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.client_key)
  cluster_ca_certificate  = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.cluster_ca_certificate)

}


provider "helm" {
  kubernetes {

  host                    = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.host #module.AKSClus.KubeAdminCFG_HostName
  username                = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.username
  password                = data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.password
  client_certificate      = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.client_certificate)
  client_key              = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.client_key)
  cluster_ca_certificate  = base64decode(data.azurerm_kubernetes_cluster.AKSCluster.kube_admin_config.0.cluster_ca_certificate)

  }
}

locals {

  ResourcePrefix                        = "${lower(var.Company)}${lower(var.CountryTag)}"

}

######################################################################
# installing kured from helm

resource "helm_release" "kured" {
  name                                = "kured"
  repository                          = "https://weaveworks.github.io/kured"
  chart                               = "kured"
  version                             = var.kuredChartVer
  namespace                           = "kured"
  create_namespace                    = true

  dynamic "set" {
    for_each                          = var.HelmKuredParam
    iterator                          = each
    content {
      name                            = each.value.ParamName
      value                           = each.value.ParamValue
    }

  }

  set_sensitive {
    name                              = var.HelmKuredSensitiveParamName
    value                             = var.HelmKuredSensitiveParamValue
  }
}

######################################################################
# installing pod identity from helm

resource "helm_release" "podidentity" {
  name                                = "podidentity"
  repository                          = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart                               = "aad-pod-identity"
  version                             = var.PodIdChartVer
  namespace                           = "podidentity"
  create_namespace                    = true


  dynamic "set" {
    for_each                          = var.HelmPodIdentityParam
    iterator                          = each
    content {
      name                            = each.value.ParamName
      value                           = each.value.ParamValue
    }

  }

  depends_on = [
    
  ]

}

######################################################################
# installing csi secret store from helm
/*
resource "helm_release" "csisecretstore" {
  name                                = "secrets-store-csi-driver"
  repository                          = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart                               = "secrets-store-csi-driver"
  version                             = var.CSISecretStoreChartVer
  namespace                           = "csisecretstore"
  create_namespace                    = true

  dynamic "set" {
    for_each                          = var.HelmCSISecretStoreParam
    iterator                          = each
    content {
      name                            = each.value.ParamName
      value                           = each.value.ParamValue
    }

  }



  depends_on = [
    
  ]

}
*/
######################################################################
# installing csi secret store key vault provider from helm

resource "helm_release" "csisecretstorekvprovider" {
  name                                = "csisecretstorekvprovider"
  repository                          = "https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
  chart                               = "csi-secrets-store-provider-azure"
  version                             = var.CSISecretStoreKvPRoviderChartVer
  namespace                           = "csisecretstorekvprovider"
  create_namespace                    = true

  dynamic "set" {
    for_each                          = var.HelmCSISecretStoreKVProviderParam
    iterator                          = each
    content {
      name                            = each.value.ParamName
      value                           = each.value.ParamValue
    }

  }


  depends_on = [
    #helm_release.csisecretstore
  ]

}

######################################################################
# installing consul from helm

resource "helm_release" "consul" {
  name       = "consul"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version                             = var.ConsulChartVer
  namespace                           = "consul"
  create_namespace                    = true

  values = [
    "${file("./consulconfig.yaml")}"
  ]
}

/*
######################################################################
# installing Velero from helm
data "template_file" "veleroyamlconfig" {
  template                                 = file("./template/veleroyamlconfig.yaml")
  vars = {
    subid                                   = data.azurerm_subscription.current.subscription_id
    rgname                                  = data.azurerm_resource_group.AKSRG.name
    agicname                                = data.terraform_remote_state.AKSClus.outputs.AGWName
    PodIdentityId                           = module.UAIAGIC.FullUAIOutput.id
    PodIdentityclientId                     = module.UAIAGIC.FullUAIOutput.client_id
    IsRBACEnabled                           = true
  }
}
resource "helm_release" "velero" {
  name                                = "cert-manager"
  repository                          = "https://vmware-tanzu.github.io/helm-charts"
  chart                               = "velero"
  version                             = var.VeleroChartVer
  namespace                           = "velero"
  create_namespace                    = true
  dynamic "set" {
    for_each                          = var.HelmVeleroParam
    iterator                          = each
    content {
      name                            = each.value.ParamName
      value                           = each.value.ParamValue
    }
  }
  depends_on = [
    
  ]
}

*/

######################################################################
# installing cert-manager from helm

resource "helm_release" "cert-manager" {
  name                                = "cert-manager"
  repository                          = "https://charts.jetstack.io"
  chart                               = "cert-manager"
  version                             = var.CerManagerChartVer
  namespace                           = "certmanager"
  create_namespace                    = true
  dynamic "set" {
    for_each                          = var.HelmCerManagerParam
    content {
      name                            = set.value.ParamName
      value                           = set.value.ParamValue
    }
  }
  depends_on = [
    
  ]
}
/*
######################################################################
# installing azure service operator from helm

resource "helm_release" "azure-service-operator" {
  name                                = "aso2"
  repository                          = "https://raw.githubusercontent.com/Azure/azure-service-operator/main/v2/"
  chart                               = "aso2"
  namespace                           = "azure-service-operator"
  create_namespace                    = true
  devel                               = true

  dynamic "set" {
    for_each                          = local.HelmAzureServiceOperatorParam
    content {
      name                            = set.value.ParamName
      value                           = set.value.ParamValue
    }
  }

  depends_on = [
    helm_release.cert-manager
  ]

}
*/