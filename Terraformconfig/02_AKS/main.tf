######################################################################
# backend block for partial configuration
######################################################################

terraform {
  backend "azurerm" {}
}

######################################################################
# Access to Azure
######################################################################

provider "azurerm" {
  subscription_id                          = var.AzureSubscriptionID
  client_id                                = var.AzureClientID
  client_secret                            = var.AzureClientSecret
  tenant_id                                = var.AzureTenantID

  features {}
  
}

######################################################################
# Module call
######################################################################

######################################################################
# Module for AKS

# UAI for AKS

module "UAI_AKS" {

  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest/Modules_building_blocks/441_UserAssignedIdentity/"
  
  #Module variable
  UAISuffix                               = "aks-${lower(var.AKSClusSuffix)}"
  TargetRG                                = data.azurerm_resource_group.AKSRG.name

}

# AKS Cluster

module "AKS1" {
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Custom_Modules/IaaS_AKS_ClusterwithRBAC_AzureCNI/"

  #Module variable
  STASubLogId                             = data.azurerm_storage_account.STALog.id
  LawSubLogId                             = data.azurerm_log_analytics_workspace.LAWLog.id

  AKSLocation                             = data.azurerm_resource_group.AKSRG.location
  AKSRGName                               = data.azurerm_resource_group.AKSRG.name
  AKSSubnetId                             = data.azurerm_subnet.fesubnet.id
  AKSNetworkPlugin                        = "kubenet"
  #AKSNetPolProvider                       = null
  AKSClusSuffix                           = var.AKSClusSuffix
  AKSIdentityType                         = "UserAssigned"
  UAIIds                                  = [module.UAI_AKS.FullUAIOutput.id]
  PublicSSHKey                            = data.azurerm_key_vault_secret.AKSSSHKey.value
  IsAGICEnabled                           = var.IsAGICEnabled
  AGWId                                   = null #var.IsAGICEnabled ? module.AGW[0].AppGW.id : null
  PrivateClusterPublicFqdn                = var.PrivateClusterPublicFqdn
  PrivateDNSZoneId                        = null   #"/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-dns/providers/Microsoft.Network/privateDnsZones/privatelink.westeurope.azmk8s.io"
  IsAKSPrivate                            = var.IsAKSPrivate
  ACG1Id                                  = data.azurerm_monitor_action_group.SubACG.id
  AKSClusterAdminsIds                     = [var.AKSClusterAdminsIds]
  ResourceOwnerTag                        = var.ResourceOwnerTag
  CountryTag                              = var.CountryTag
  CostCenterTag                           = var.CostCenterTag
  Environment                             = var.Environment
  Project                                 = var.Project
  TaintCriticalAddonsEnabled              = true

}

######################################################################
# Mapping AKS Identity to subscription - DNS Operator

module "AssignAKS_UAI_DNSContrib_To_Sub" {

  count                                   = var.IsAKSPrivate ? 1 : 0
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Private DNS Zone Contributor"
  ObjectId                                = module.UAI_AKS.PrincipalId

}

######################################################################
# Creating an Application Gateway
/*
locals {

  SitesConf = {
    "Site 1" = {
      SiteIdentifier                                = data.azurerm_key_vault_certificate.AGWCertForAGICCert.name 
      AppGWSSLCertNameSite                          = data.azurerm_key_vault_certificate.AGWCertForAGICCert.name 
      AppGwPublicCertificateSecretIdentifierSite    = data.azurerm_key_vault_secret.AGWCertForAGICSecret.id
      HostnameSite                                  = "aks.teknews.cloud"
    }
  }
}


module "AGW" {

  count                                         = var.IsAGICEnabled ? 1 : 0
  source                                        = "github.com/dfrappart/Terra-AZModuletest//Custom_Modules//232_AppGW_w_dynamicblock"

  TargetRG                                      = data.azurerm_resource_group.InfraRG.name
  TargetLocation                                = module.ResourceGroup.RGLocation
  LawSubLogId                                   = data.azurerm_log_analytics_workspace.LAWLog.id
  STASubLogId                                   = data.azurerm_storage_account.STALog.id
  TargetSubnetId                                = module.AKSVNet.AGWSubnetFullOutput.id
  KVId                                          = data.terraform_remote_state.Subsetupstate.outputs.AKSKeyVault_Id
  SitesConf                                     = local.SitesConf
  AGWSuffix                                     = var.ResourcesSuffix
  TargetSubnetAddressPrefix                     = module.AKSVNet.AGWSubnetFullOutput.address_prefixes[0]


  # Tags
  ResourceOwnerTag                              = var.ResourceOwnerTag
  CountryTag                                    = var.CountryTag
  CostCenterTag                                 = var.CostCenterTag
  Project                                       = var.Project
  Environment                                   = var.Environment

}
*/

######################################################################
# Requirement for Pod Identity
######################################################################

######################################################################
# Mapping AKS Identity to subscription - Managed Identity Operator

module "AssignAKS_SAI_ManagedIdentityOps_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Managed Identity Operator"
  ObjectId                                = module.UAI_AKS.PrincipalId

}

######################################################################
# Mapping AKS Identity to subscription - VM Contributor

module "AssignAKS_SAI_VMContributor_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Virtual Machine Contributor"
  ObjectId                                = module.UAI_AKS.PrincipalId

}

######################################################################
# Mapping AKS Identity to Subscription - Network Contributor

module "AssignAKS_SAI_NTWContributor_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Network Contributor"
  ObjectId                                = module.UAI_AKS.PrincipalId

}

######################################################################
# Mapping AKS Kubelet UAI to subscription - Managed Identity Operator

module "AssignAKS_KubeletUAI_ManagedIdentityOps_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Managed Identity Operator"
  ObjectId                                = module.AKS1.FullAKS.kubelet_identity[0].object_id

}


######################################################################
# Mapping AKS Kubelet UAI to Subscription - VM Operator role

module "AssignAKS_KubeletUAI_VMContributor_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Virtual Machine Contributor"
  ObjectId                                = module.AKS1.FullAKS.kubelet_identity[0].object_id

}


######################################################################
# Mapping AKS Kubelet UAI to Subscription - Network Contributor

module "AssignAKS_KubeletUAI_NTWContributor_To_Sub" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/401_RBACAssignment_BuiltinRole/"

  #Module variable
  RBACScope                               = data.azurerm_subscription.current.id
  BuiltinRoleName                         = "Network Contributor"
  ObjectId                                = module.AKS1.FullAKS.kubelet_identity[0].object_id

}


######################################################################
# Module for AKS Node Pool

module "AKS_NodePool" {

  for_each                                = {
    for k,v in var.AKSNodePoolConfig : k=>v if v.IsNodePoolDeployed == true
    }
  #Module Location
  source                                  = "../../Modules/IaaS_AKS_NodePool/"

  #Module variable

  NPSuffix                                = each.key
  AKSClusterId                            = module.AKS1.KubeId
  MinAutoScaleCount                       = 3
  AKSNodeTaints                           = each.value.AKSNodeTaints
  #AKSNodeLabels                           = each.value.AKSNodeLabels
  AKSSubnetId                             = data.azurerm_subnet.fesubnet.id


}

######################################################################
# Module for ACR Pool

module "ACR" {
    #Module source
    source = "../../Modules/PaaS_Azure_Container_Registry/"

    #Module variables
    
    ACRRG                       = data.azurerm_resource_group.AKSRG.name
    ACRLocation                 = data.azurerm_resource_group.AKSRG.location  
    STALogId                    = data.azurerm_storage_account.STALog.id
    LawLogId                    = data.azurerm_log_analytics_workspace.LAWLog.id
    IsACRAssociatedtoAKSCluster = true
    AKSKubeletPrincipalId       = module.AKS1.FullAKS.kubelet_identity[0].object_id
    ACRReplList                 = var.ACRReplList




}

/*
######################################################################
# creating ACI for dataload
resource "azurerm_container_group" "dataload" {
  name                = "dataload"
  location            = "westeurope" #data.azurerm_resource_group.AKSRG.location
  resource_group_name = data.azurerm_resource_group.AKSRG.name
  ip_address_type     = "public"
  #dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "dataload"
    image  = "acrbvcc1.azurecr.io/dataload:1.0"
    cpu    = "0.5"
    memory = "1.5"
    secure_environment_variables = {
      "SQLFQDN"="mssqlconsul.database.windows.net" 
      "SQLUSER"="MSSQLAdminLogin-consul" 
      "SQLPASS"="" 
      "SQLDB"="mydrivingDB"
      
    }

  }



  tags = var.DefaultTags
}
*/