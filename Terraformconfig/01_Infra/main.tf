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

  features {

    resource_group {
    
      prevent_deletion_if_contains_resources = false
    
    }
  }
  
}

######################################################################
# Module call
######################################################################

# Creating the Resource Group

module "ResourceGroup" {
  count                                   = length(var.ResourceGroupSuffixList)
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/003_ResourceGroup/"
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
  NetworkWatcherName                      = "NetworkWatcher_${module.ResourceGroup[0].RGLocation}"
  IsTrafficAnalyticsEnabled               = false
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
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/412_KeyvaultSecret/"

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
  TargetSubnetId                          = module.SpokeVNet[each.key].BESubnetFullOutput.id
  STABlobURI                              = data.azurerm_storage_account.STALog.primary_blob_endpoint
  VMSuffix                                = "${each.key}-${var.ResourcesSuffix}"
  VmSize                                  = "Standard_D2s_v3"
  OSDiskTier                              = "StandardSSD_LRS"
  #CloudinitscriptPath                     = var.CloudinitscriptPath
  VmAdminPassword                         = module.SecretTest_to_KV[each.key].SecretFullOutput.value


  DefaultTags                             = var.DefaultTags
}


######################################################################
# allow http/s on fe

module "NSGRuleHTTPAllow_FromInternetToFE" {
  
  #Module location
  source = "../../Modules/222_NSGRule/"

  #Module variable
  RuleSuffix                      = "NSGRuleHTTPAllow_FromInternetToFE"
  RulePriority                    = 1011
  RuleDirection                   = "Inbound"
  RuleAccess                      = "Allow"
  RuleProtocol                    = "Tcp"
  RuleDestPorts                    = [80,443]
  RuleSRCAddressPrefix            = "Internet"
  RuleDestAddressPrefix           = "*"
  TargetRG                        = module.SpokeVNet["Spoke1"].FESubnetNSGFullOutput.resource_group_name
  TargetNSG                       = module.SpokeVNet["Spoke1"].FESubnetNSGFullOutput.name


}



######################################################################
# creating an azure sql server for lab usage


# SQL Admin pwd to KV
module "MSSQLAdminPWD" {

  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/412_KeyvaultSecret/"

  #Module variable     
  KeyVaultSecretSuffix                    = "MSSQLAdminPWD-${var.ResourcesSuffix}" #tfsec:ignore:general-secrets-no-plaintext-exposure
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

# MS SQL Server
resource "azurerm_mssql_server" "SQLAppServer1" {
  name                                    = "mssql${var.ResourcesSuffix}"
  resource_group_name                     = module.ResourceGroup[2].RGName
  location                                = module.ResourceGroup[2].RGLocation
  version                                 = var.MSSQLVer #"12.0"
  administrator_login                     = "MSSQLAdminLogin-${var.ResourcesSuffix}"
  administrator_login_password            = module.MSSQLAdminPWD.SecretFullOutput.value
  minimum_tls_version                     = var.MSSQLTLSVersion #"1.2"

  azuread_administrator {
    login_username                        = "mssqlazureadadmin-${var.ResourcesSuffix}"
    object_id                             = var.MSSQLADAdminObjectId
  }

  connection_policy                       = var.MSSQLConnectionPolicy

  identity {
    type                                  = var.MSSQLIdentityType
    identity_ids                          = var.MSSQLUAIId
  }

  public_network_access_enabled           = var.MSSQLPublicNetworkAccessEnabled

  outbound_network_restriction_enabled    = var.MSSQLEgressRestrictionEnabled


  tags                                    = var.DefaultTags
}

# MS SQL Server VNet rule
resource "azurerm_mssql_virtual_network_rule" "VNetRule-SQLAppServer1" {
  name                                    = "VNetRule-${azurerm_mssql_server.SQLAppServer1.name}"
  server_id                               = azurerm_mssql_server.SQLAppServer1.id
  subnet_id                               = module.SpokeVNet["Spoke1"].FESubnetFullOutput.id 
}

# MS SQL Server FW rule
resource "azurerm_mssql_firewall_rule" "AllowAzureSVC" {
  count            = var.MSSQLAcceptAzureService ? 1 : 0
  name             = "AllowAzureSVC"
  server_id        = azurerm_mssql_server.SQLAppServer1.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# MSSQL RBAC Assignment to interact with storage account for logs
resource "azurerm_role_assignment" "MSSQLSRVRBACForAudit" {
  scope                = data.azurerm_storage_account.STALog.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.SQLAppServer1.identity.0.principal_id
}

# MS SQL Server Extended auditing policy
resource "azurerm_mssql_server_extended_auditing_policy" "SQLAppServer1_ExtendedAuditingPolicy" {
  storage_endpoint       = data.azurerm_storage_account.STALog.primary_blob_endpoint
  server_id              = azurerm_mssql_server.SQLAppServer1.id
  retention_in_days      = var.MSSQLSRVExtendedAutitingPolicyRetentionInDays
  log_monitoring_enabled = var.MSSQLDBExtendedAutitingPolicyLogMonitoringEnabled


  depends_on = [
    azurerm_role_assignment.MSSQLSRVRBACForAudit,
  ]
}

resource "azurerm_mssql_database" "SQLDBMyDrivingDB" {
  name                                    = var.MSSQLDBName
  server_id                               = azurerm_mssql_server.SQLAppServer1.id
  auto_pause_delay_in_minutes             = var.MSSQLDBAutoPauseDelay
  create_mode                             = var.MSSQLDBCreateMode
  creation_source_database_id             = var.MSSQLDBCreationSrcId 
  collation                               = var.MSSQLDBCollation
  elastic_pool_id                         = var.MSSQLDBElasticPoolId
  geo_backup_enabled                      = var.MSSQLDBGeoBackupEnabled
  license_type                            = var.MSSQLDBLicenseType
  long_term_retention_policy {
    weekly_retention                      = var.MSSQLDBLongTermRentetionPolicyWeeklyRetention
    monthly_retention                     = var.MSSQLDBLongTermRentetionPolicyMonthlyRetention
    yearly_retention                      = var.MSSQLDBLongTermRentetionPolicyYearlyRetention
    week_of_year                          = var.MSSQLDBLongTermRentetionPolicyWeekOfYear     
  }

  short_term_retention_policy {
    retention_days                        = var.MSSQLDBShortTermRentetionPolicyRetentionDays   
  }

  max_size_gb                             = var.MSSQLDBMaxSize
  min_capacity                            = var.MSSQLDBMinCapacity
  restore_point_in_time                   = var.MSSQLDBRestorePoinInTime
  recover_database_id                     = var.MSSQLDBRecoverDatabaseId
  restore_dropped_database_id             = var.MSSQLDBRestoreDroppedDatabaseId
  read_replica_count                      = var.MSSQLDBReadReplicaCount
  read_scale                              = var.MSSQLDBReadScale
  sku_name                                = var.MSSQLDBSku
  storage_account_type                    = var.MSSQLDBStaType
  zone_redundant                          = var.MSSQLDBZoneRedundant

  threat_detection_policy {
    state                                 = var.MSSQLDBThreatDetectionPolicyState
    disabled_alerts                       = var.MSSQLDBThreatDetectionPolicyDisabledAlerts 
    email_account_admins                  = var.MSSQLDBThreatDetectionPolicyEmailAccountAdmins
    email_addresses                       = var.MSSQLDBThreatDetectionPolicyEmail
    retention_days                        = var.MSSQLDBThreatDetectionPolicyRetentionDays
    storage_account_access_key            = data.azurerm_storage_account.STALog.primary_access_key 
    storage_endpoint                      = data.azurerm_storage_account.STALog.primary_blob_endpoint   

  }

  tags = var.DefaultTags

}

resource "azurerm_mssql_database_extended_auditing_policy" "SQLDBMyDrivingDBExtendedAutitingPolicy" {
  database_id                             = azurerm_mssql_database.SQLDBMyDrivingDB.id
  storage_endpoint                        = data.azurerm_storage_account.STALog.primary_blob_endpoint
  storage_account_access_key              = data.azurerm_storage_account.STALog.primary_access_key
  storage_account_access_key_is_secondary = var.MSSQLDBExtendedAutitingPolicySTAAccessKeyIsSecondary
  retention_in_days                       = var.MSSQLDBExtendedAutitingPolicyRetentionInDays
  log_monitoring_enabled                  = var.MSSQLDBExtendedAutitingPolicyLogMonitoringEnabled
}