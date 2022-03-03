##############################################################
#Variable declaration for provider

variable "AzureSubscriptionID" {
  type                                  = string
  description                           = "The subscription id for the authentication in the provider"
}

variable "AzureClientID" {
  type                                  = string
  description                           = "The application Id, taken from Azure AD app registration"
}


variable "AzureClientSecret" {
  type                                  = string
  description                           = "The Application secret"

}

variable "AzureTenantID" {
  type                                  = string
  description                           = "The Azure AD tenant ID"
}

######################################################
# Common variables

variable "AzureRegion" {
  type                                  = string
  description                           = "The Azure region for deployment"
  default                               = "westeurope"
}

variable "ResourceOwnerTag" {
  type                                  = string
  description                           = "Tag describing the owner"
  default                               = "That would be me"
}

variable "CountryTag" {
  type                                  = string
  description                           = "Tag describing the Country"
  default                               = "fr"
}

variable "CostCenterTag" {
  type                                  = string
  description                           = "Tag describing the Cost Center"
  default                               = "labconsul"
}

variable "Project" {
  type                                  = string
  description                           = "The name of the project"
  default                               = "aro"
}

variable "Environment" {
  type                                  = string
  description                           = "The environment, dev, prod..."
  default                               = "lab"
}

variable "ResourcesSuffix" {
  type                                  = string
  description                           = "A suffix to add globallyon the resources"
  default                               = ""
}

variable "ResourceGroupSuffixList" {
  type                                  = list(string)
  description                           = "A list of potential suffix, gfor the case we could havemore than one RG"
  default                               = [""]
}

variable "SpokeVnetConfig" {
  type = map(object({
    VNetAddressSpace                    = string
    VNetSuffix                          = string
    IsBastionEnabled                    = bool
    IsVMDeployed                        = bool
  }))
  description                           = "A map to configure the VNets"
}

variable "DefaultTags" {

  description                           = "Define a set of default tags"
  
}

variable "ExtraTags" {
  type                                  = map
  description                           = "Define a set of additional optional tags."
  default                               = {}
}

######################################################
# Data sources variables

variable "SubsetupSTOAName" {
  type                                  = string
  description                           = "Name of the storage account containing the remote state"
}

variable "SubsetupAccessKey" {
  type                                  = string
  description                           = "Access Key of the storage account containing the remote state"
}

variable "SubsetupContainerName" {
  type                                  = string
  description                           = "Name of the container in the storage account containing the remote state"
}

variable "SubsetupKey" {
  type                                  = string
  description                           = "State key"
}

######################################################
# MSSQL variables

# SRV parameters

variable "MSSQLVer" {
  type                                  = string
  description                           = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default                               = "12.0"
}

variable "MSSQLTLSVersion" {
  type                                  = string
  description                           = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2."
  default                               = "1.2"
}

variable "MSSQLADAdminObjectId" {
  type                                  = string
  description                           = "The object id of the Azure AD Administrator of this SQL Server."
}


variable "MSSQLConnectionPolicy" {
  type                                  = string
  description                           = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default."
  default                               = null
}

variable "MSSQLPublicNetworkAccessEnabled" {
  type                                  = bool
  description                           = "Whether public network access is allowed for this server. Defaults to true."
  default                               = true
}

variable "MSSQLEgressRestrictionEnabled" {
  type                                  = bool
  description                           = "Whether outbound network traffic is restricted for this server. Defaults to false."
  default                               = false
}

variable "MSSQLIdentityType" {
  type                                  = string
  description                           = "Specifies the identity type of the Microsoft SQL Server. Possible values are SystemAssigned (where Azure will generate a Service Principal for you) and UserAssigned where you can specify the Service Principal IDs in the user_assigned_identity_ids field."
  default                               = "SystemAssigned"
}

variable "MSSQLUAIId" {
  type                                  = list(string)
  description                           = "Specifies a list of User Assigned Identity IDs to be assigned. Required if type is UserAssigned and should be combined with primary_user_assigned_identity_id."
  default                               = null
}


# DB parameters

variable "MSSQLDBName" {
  type                                  = string
  description                           = "The name of the Ms SQL Database. Changing this forces a new resource to be created."
  default                               = "mydrivingDB"
}

variable "MSSQLDBCollation" {
  type                                  = string
  description                           = "Specifies the collation of the database. Changing this forces a new resource to be created."
  default                               = null
}

variable "MSSQLDBAutoPauseDelay" {
  type                                  = string
  description                           = "Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases."
  default                               = null
}

variable "MSSQLDBCreateMode" {
  type                                  = string
  description                           = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. "
  default                               = null
}


variable "MSSQLDBCreationSrcId" {
  type                                  = string
  description                           = "The ID of the source database from which to create the new database. This should only be used for databases with create_mode values that use another database as reference. Changing this forces a new resource to be created."
  default                               = null
}

variable "MSSQLDBElasticPoolId" {
  type                                  = string
  description                           = "Specifies the ID of the elastic pool containing this database."
  default                               = null
}

variable "MSSQLDBGeoBackupEnabled" {
  type                                  = bool
  description                           = "A boolean that specifies if the Geo Backup Policy is enabled. geo_backup_enabled is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs."
  default                               = null
}

variable "MSSQLDBLicenseType" {
  type                                  = string
  description                           = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  default                               = null
}

variable "MSSQLDBMaxSize" {
  type                                  = string
  description                           = "The max size of the database in gigabytes."
  default                               = null
}

variable "MSSQLDBMinCapacity" {
  type                                  = string
  description                           = "Minimal capacity that database will always have allocated, if not paused. This property is only settable for General Purpose Serverless databases."
  default                               = null
}

variable "MSSQLDBRestorePoinInTime" {
  type                                  = string
  description                           = "Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create_mode= PointInTimeRestore databases."
  default                               = null
}

variable "MSSQLDBRecoverDatabaseId" {
  type                                  = string
  description                           = "The ID of the database to be recovered. This property is only applicable when the create_mode is Recovery."
  default                               = null
}

variable "MSSQLDBRestoreDroppedDatabaseId" {
  type                                  = string
  description                           = "The ID of the database to be restored. This property is only applicable when the create_mode is Restore."
  default                               = null
}

variable "MSSQLDBReadReplicaCount" {
  type                                  = string
  description                           = "The number of readonly secondary replicas associated with the database to which readonly application intent connections may be routed. This property is only settable for Hyperscale edition databases."
  default                               = null
}

variable "MSSQLDBReadScale" {
  type                                  = bool
  description                           = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
  default                               = null
}

variable "MSSQLDBSku" {
  type                                  = string
  description                           = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will force a new resource to be created."
  default                               = null
}

variable "MSSQLDBStaType" {
  type                                  = string
  description                           = "Specifies the storage account type used to store backups for this database. Changing this forces a new resource to be created. Possible values are GRS, LRS and ZRS. The default value is GRS."
  default                               = null
}

variable "MSSQLDBZoneRedundant" {
  type                                  = bool
  description                           = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
  default                               = null
}

# DB Threat detection policy parameters

variable "MSSQLDBThreatDetectionPolicyRetentionDays" {
  type                                  = string
  description                           = "Specifies the number of days to keep in the Threat Detection audit logs."
  default                               = 365
}

variable "MSSQLDBThreatDetectionPolicyEmail" {
  type                                  = list(string)
  description                           = "A list of email addresses which alerts should be sent to."
  default                               = null
}

variable "MSSQLDBThreatDetectionPolicyEmailAccountAdmins" {
  type                                  = bool
  description                           = "Should the account administrators be emailed when this alert is triggered?"
  default                               = null
}

variable "MSSQLDBThreatDetectionPolicyDisabledAlerts" {
  type                                  = list
  description                           = "Specifies a list of alerts which should be disabled. Possible values include Access_Anomaly, Sql_Injection and Sql_Injection_Vulnerability."
  default                               = null
}

variable "MSSQLDBThreatDetectionPolicyState" {
  type                                  = string
  description                           = "The State of the Policy. Possible values are Enabled, Disabled or New."
  default                               = "Enabled"
}

# DB short retention policy parameters

variable "MSSQLDBShortTermRentetionPolicyRetentionDays" {
  type                                  = string
  description                           = "Point In Time Restore configuration. Value has to be between 7 and 35."
  default                               = 35
}

# DB Long retention policy parameters
variable "MSSQLDBLongTermRentetionPolicyWeeklyRetention" {
  type                                  = string
  description                           = "The weekly retention policy for an LTR backup in an ISO 8601 format. Valid value is between 1 to 520 weeks. e.g. P1Y, P1M, P1W or P7D."
  default                               = "P8W"
}

variable "MSSQLDBLongTermRentetionPolicyMonthlyRetention" {
  type                                  = string
  description                           = "The monthly retention policy for an LTR backup in an ISO 8601 format. Valid value is between 1 to 120 months. e.g. P1Y, P1M, P4W or P30D."
  default                               = "P12M"
}

variable "MSSQLDBLongTermRentetionPolicyYearlyRetention" {
  type                                  = string
  description                           = "The yearly retention policy for an LTR backup in an ISO 8601 format. Valid value is between 1 to 10 years. e.g. P1Y, P12M, P52W or P365D."
  default                               = "P5Y"
}

variable "MSSQLDBLongTermRentetionPolicyWeekOfYear" {
  type                                  = string
  description                           = "he week of year to take the yearly backup in an ISO 8601 format. Value has to be between 1 and 52."
  default                               = 52
}

# DB extended auditing policy parameters
variable "MSSQLDBExtendedAutitingPolicyRetentionInDays" {
  type                                  = string
  description                           = "The number of days to retain logs for in the storage account."
  default                               = 365
}

variable "MSSQLDBExtendedAutitingPolicyLogMonitoringEnabled" {
  type                                  = bool
  description                           = "Enable audit events to Azure Monitor? "
  default                               = false
}


variable "MSSQLDBExtendedAutitingPolicySTAAccessKeyIsSecondary" {
  type                                  = bool
  description                           = "Enable audit events to Azure Monitor? "
  default                               = false
}

# SRV extended auditing policy parameters

variable "MSSQLSRVExtendedAutitingPolicyRetentionInDays" {
  type                                  = string
  description                           = "The number of days to retain logs for in the storage account."
  default                               = 365
}

variable "MSSQLSRVExtendedAutitingPolicyLogMonitoringEnabled" {
  type                                  = bool
  description                           = "Enable audit events to Azure Monitor? "
  default                               = false
}


variable "MSSQLSRVExtendedAutitingPolicySTAAccessKeyIsSecondary" {
  type                                  = bool
  description                           = "Enable audit events to Azure Monitor? "
  default                               = false
}

# MS SQL Server FW rule
variable "MSSQLAcceptAzureService" {
  type                                  = bool
  description                           = "A flag to activate or deactivate the Azure Service Allowed on the SQL Server"
  default                               = false
}