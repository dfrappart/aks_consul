##############################################################
#config variables
##############################################################

##############################################
#Variable for using subscription setup state as a data source

variable "SubsetupSTOAName" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "SubsetupContainerName" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "SubsetupKey" {
  type    = string
  description = "The storage access key of the storage account"
}

variable "SubsetupAccessKey" {
  type    = string
  description = "The state file name for the subsetup state"
}

##############################################
#Variable for using infra state as a data source

variable "InfrasetupSTOAName" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "InfraSetupContainerName" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "InfraSetupAccessKey" {
  type    = string
  description = "he storage access key of the storage account"
}

variable "statekeyInfraState" {
  type    = string
  description = "the name of the file containing the state of the 02 Azure Autmation setup configuration"
}

##############################################
#Variable for using AKS state as a data source

variable "statestoa" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "statecontainer" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "statestoakey" {
  type    = string
  description = "The storage access key of the storage account"
}

variable "statekeyAKSClusState" {
  type    = string
  description = "The state file name for the aks state"
}



######################################################
#Tag related variables and naming convention section

variable "ResourceOwnerTag" {
  type          = string
  description   = "Tag describing the owner"
  default       = "That would be me"
}

variable "CountryTag" {
  type          = string
  description   = "Tag describing the Rexel Country"
  default       = "fr"
}

variable "CostCenterTag" {
  type          = string
  description   = "Tag describing the Cost Center"
  default       = "k8slab"
}

variable "Company" {
  type          = string
  description   = "The Company owner of the resources"
  default       = "dfitc"
}

variable "Project" {
  type          = string
  description   = "The name of the project"
  default       = "agic"
}

variable "Environment" {
  type          = string
  description   = "The environment, dev, prod..."
  default       = "lab"
}

##############################################################
#Variable declaration for provider azure

variable "AzureSubscriptionID" {
  type                          = string
  description                   = "The subscription id for the authentication in the provider"
}



variable "AzureClientID" {
  type                          = string
  description                   = "The application Id, taken from Azure AD app registration"
}


variable "AzureClientSecret" {
  type                          = string
  description                   = "The Application secret"

}

variable "AzureTenantID" {
  type                          = string
  description                   = "The Azure AD tenant ID"
}

##############################################################
#Variable declaration for provider kube

variable "kubepath" {
  type                          = string
  description                   = "path to kube config file"
  default = "value"

}

variable "kubecontext" {
  type                          = string
  description                   = "Name of the kubernetes context"
  default = "value"
}

##############################################################
#Variable declaration for helm kured set

variable "ConsulChartVer" {
  type                          = string
  description                   = "The version of the chart"
  default                       = "0.40.0"
}

variable "ConsulChartParam" {
  type                  = map(object({
    ParamName           = string
    ParamValue          = string
  }))
  description            = "A map used to feed the dynamic blocks of the cilium helm chart"
  default                = {

      "set1" = {
        ParamName             = "nodeinit.enabled"
        ParamValue            = "true"

      }
  }
}

##############################################################
#Variable declaration for helm pod identity set

variable "PodIdChartVer" {
  type                          = string
  description                   = "The version of the chart"
  default                       = "4.1.5"
}

variable "HelmPodIdentityParam" {
  type                  = map
  description            = "A map used to feed the dynamic blocks of the pod identity helm chart"
  default                = {

      "set1" = {
        ParamName             = "nmi.allowNetworkPluginKubenet"
        ParamValue            = "true"

    }
      "set2" = {
        ParamName             = "installCRDs"
        ParamValue            = "true"

    }

  }

}

##############################################################
#Variable declaration for helm secret store csi driver set

variable "CSISecretStoreChartVer" {
  type                          = string
  description                   = "The version of the chart"
  default                       = "0.3.0"
}

variable "HelmCSISecretStoreParam" {
  type                  = map
  description            = "A map used to feed the dynamic blocks of the pod identity helm chart"
  default                = {

      "set1" = {
        ParamName             = "secrets-store-csi-driver.enableSecretRotation"
        ParamValue            = "true"

    }

      "set2" = {
        ParamName             = "secrets-store-csi-driver.rotationPollInterval"
        ParamValue            = "1m"

    }

      "set3" = {
        ParamName             = "syncSecret.enabled"
        ParamValue            = "true"

    }
  }

}

##############################################################
#Variable declaration for secret store csi driver kv provider

variable "CSISecretStoreKvPRoviderChartVer" {
  type                          = string
  description                   = "The version of the chart"
  default                       = "0.2.1"
}

variable "HelmCSISecretStoreKVProviderParam" {
  type                  = map
  description            = "A map used to feed the dynamic blocks of the pod identity helm chart"
  default                = {

      "set1" = {
        ParamName             = "secrets-store-csi-driver.install"
        ParamValue            = "true"

    }
      "set2" = {
        ParamName             = "secrets-store-csi-driver.enableSecretRotation"
        ParamValue            = "true"

    }

      "set3" = {
        ParamName             = "secrets-store-csi-driver.rotationPollInterval"
        ParamValue            = "1m"

    }

      "set4" = {
        ParamName             = "syncSecret.enabled"
        ParamValue            = "true"

    }
  }

}