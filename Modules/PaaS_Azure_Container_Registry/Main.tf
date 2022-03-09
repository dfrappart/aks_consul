##############################################################
#This module allows the creation of container registry
##############################################################

##############################################################
#Creating an ACR


resource "random_string" "ACRRandomString" {

  length                                = var.stringlenght
  upper                                 = false
  special                               = false 



}

resource "azurerm_container_registry" "ACR" {
  name                                  = var.ACRSuffix == "" ? "acr${random_string.ACRRandomString.result}" : "acr${lower(var.ACRSuffix)}"
  resource_group_name                   = var.ACRRG
  location                              = var.ACRLocation
  admin_enabled                         = var.IsAdminEnabled

  sku                                   = var.ACRSku
  #georeplication_locations              = var.ACRReplList

  dynamic "georeplications" {
    for_each                            = var.ACRReplList


    content {
      location                          = georeplications.value.Location
      zone_redundancy_enabled           = georeplications.value.ZoneRedundancyEnabled
      tags                              = merge(var.DefaultTags,var.ExtraTags,{"ACRMainRegion"=var.ACRLocation})
    }
  }



  tags                                  = merge(var.DefaultTags,var.ExtraTags)

}

##############################################################
# Assignment for AKS cluster

resource "azurerm_role_assignment" "AKS_ACR_Association" {
  count                                 = var.IsACRAssociatedtoAKSCluster ? 1 : 0
  principal_id                          = var.AKSKubeletPrincipalId
  role_definition_name                  = "AcrPull"
  scope                                 = azurerm_container_registry.ACR.id
  skip_service_principal_aad_check      = true
}

################################################################
# Diagnostic settings resource

resource "azurerm_monitor_diagnostic_setting" "ACRDiag" {
  name                                  = "diag-${azurerm_container_registry.ACR.name}"
  target_resource_id                    = azurerm_container_registry.ACR.id
  storage_account_id                    = var.STALogId
  log_analytics_workspace_id            = var.LawLogId

  dynamic "log" {
    for_each = var.logcategories
    iterator = each
    content {
      category                          = each.value.LogCatName
      enabled                           = each.value.IsLogCatEnabled
      retention_policy {
        enabled                         = each.value.IsRetentionEnabled
        days                            = each.value.RetentionDay
      }
    }
  }

  metric {
    category                            = "AllMetrics"
    enabled                             = true
    retention_policy {
      enabled                           = true
      days                              = 365
    }    

  }

}