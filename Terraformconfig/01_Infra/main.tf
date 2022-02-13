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

# Creating the Resource Group

module "ResourceGroup" {
  count                                   = length(var.ResourceGroupSuffixList)
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks//003_ResourceGroup/"
  #Module variable      
  RGSuffix                                = "-${var.ResourcesSuffix}-${element(var.ResourceGroupSuffixList,count.index)}"
  RGLocation                              = var.AzureRegion
  ResourceOwnerTag                        = var.ResourceOwnerTag
  CountryTag                              = var.CountryTag
  CostCenterTag                           = var.CostCenterTag
  EnvironmentTag                          = var.Environment
  Project                                 = var.Project

}



module "SpokeVNet" {
  for_each                                = var.SpokeVnetConfig
  
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Custom_Modules/IaaS_NTW_VNet_for_AppGW/"

  #Module variable
  RGLogName                               = data.azurerm_resource_group.RGLog.name
  LawSubLogName                           = data.azurerm_log_analytics_workspace.LAWLog.name
  STALogId                                = data.azurerm_storage_account.STALog.id
  TargetRG                                = module.ResourceGroup[0].RGName
  TargetLocation                          = module.ResourceGroup[0].RGLocation
  VNetSuffix                              = each.value.VNetSuffix
  IsBastionEnabled                        = each.value.IsBastionEnabled
  VNetAddressSpace                        = [each.value.VNetAddressSpace]
  ResourceOwnerTag                        = var.ResourceOwnerTag
  CountryTag                              = var.CountryTag
  CostCenterTag                           = var.CostCenterTag
  Environment                             = var.Environment
  Project                                 = var.Project

}

######################################################################
# Adding IP groups for FW usage

resource "azurerm_ip_group" "VNetIPGroups" {
  for_each                                = var.SpokeVnetConfig
  name                                    = "ipgroup-${module.SpokeVNet[each.key].VNetFullOutput.name}"
  location                                = module.ResourceGroup[0].RGLocation
  resource_group_name                     = module.ResourceGroup[0].RGName

  cidrs                                   = module.SpokeVNet[each.key].VNetFullOutput.address_space

  tags                                    = merge(var.DefaultTags, {"IPGroupType" = "VNet"})
}





######################################################################
# VM

module "SecretTest_to_KV" {

  for_each                                = {
    for k,v in var.SpokeVnetConfig : k=>v if v.IsVMDeployed == true
    }
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest/Modules_building_blocks/412_KeyvaultSecret/"

  #Module variable     
  KeyVaultSecretSuffix                    = "VMPwd-${each.key}-${var.ResourcesSuffix}"
  #PasswordValue                           = module.SecretTest.Result
  KeyVaultId                              = data.azurerm_key_vault.keyvault.id
  ResourceOwnerTag                        = var.ResourceOwnerTag
  CountryTag                              = var.CountryTag
  CostCenterTag                           = var.CostCenterTag
  Environment                             = var.Environment
  Project                                 = var.Project

  depends_on = [

  ]

}

module "VMWin" {

  for_each                                = {
    for k,v in var.SpokeVnetConfig : k=>v if v.IsVMDeployed == true
    }
  #Module Location
  source                                  = "../../Modules/IaaS_CPT_VMWinwDataDisk_NotLoadBalanced/"

  #Module variable
  LawLogId                                = data.azurerm_log_analytics_workspace.LAWLog.id
  STALogId                                = data.azurerm_storage_account.STALog.id
  TargetRG                                = module.ResourceGroup[3].RGName
  TargetLocation                          = module.SpokeVNet[each.key].VNetFullOutput.location
  TargetSubnetId                          = module.SpokeVNet[each.key].FESubnetFullOutput.id
  STABlobURI                              = data.azurerm_storage_account.STALog.primary_blob_endpoint
  VMSuffix                                = "${each.key}-${var.ResourcesSuffix}"
  VmSize                                  = "Standard_D2s_v3"
  OSDiskTier                              = "StandardSSD_LRS"
  #CloudinitscriptPath                     = var.CloudinitscriptPath
  VmAdminPassword                         = module.SecretTest_to_KV[each.key].SecretFullOutput.value


  DefaultTags                             = var.DefaultTags
}

/*
######################################################################
# allow https on agw

module "NSGRuleRDPAllow_FromBastionSpk2" {
  
  #Module location
  source = "../../Modules/222_NSGRule/"

  #Module variable
  RuleSuffix                      = "RDPAllow_FromBastionSpk2"
  RulePriority                    = 1011
  RuleDirection                   = "Inbound"
  RuleAccess                      = "Allow"
  RuleProtocol                    = "Tcp"
  RuleDestPorts                    = [3389]
  RuleSRCAddressPrefix            = module.SpokeVNet["Spoke2"].AzureBastionSubnetFullOutput.address_prefix
  RuleDestAddressPrefix           = module.SpokeVNet["Spoke1"].FESubnetFullOutput.address_prefix
  TargetRG                        = module.SpokeVNet["Spoke1"].FESubnetNSGFullOutput.resource_group_name
  TargetNSG                       = module.SpokeVNet["Spoke1"].FESubnetNSGFullOutput.name


}

*/
