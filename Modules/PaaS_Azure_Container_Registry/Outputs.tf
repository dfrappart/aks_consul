##############################################################
#This module allows the creation of a vNEt
##############################################################


#Output for the module

output "Name" {
  value                           = azurerm_container_registry.ACR.name
  description                     = "The name of the ACR"
}


output "RGName" {
  value                           = azurerm_container_registry.ACR.resource_group_name
  description                     = "The name of the RG containing the ACR"
}


output "Location" {
  value                           = azurerm_container_registry.ACR.location
  description                     = "The location of the ACR"
}

output "AdminEnabled" {
  value                           = azurerm_container_registry.ACR.admin_enabled
  description                     = "The status of the admin account state, enabled or not"
}



output "SKu" {
  value                           = azurerm_container_registry.ACR.sku
  description                     = "The ACR SKU"
}

output "ACRFull" {
  value                           = azurerm_container_registry.ACR
  description                     = "The Region in which the ACR is replicated"
  sensitive                       = true
}


output "Id" {
  value                           = azurerm_container_registry.ACR.id
  description                     = "The Container Registry ID"
}


output "ACRLoginServer" {
  value                           = azurerm_container_registry.ACR.login_server
  description                     = "The URL that can be used to log into the container registry"
}



output "ACRAdminName" {
  value                           = var.IsAdminEnabled ? azurerm_container_registry.ACR.admin_username : "Admin not enabled"
  description                     = "The Admin name of the ACR"
}



output "ACRAdminPassword" {
  value                           = var.IsAdminEnabled ? azurerm_container_registry.ACR.admin_password : "Admin not enabled"
  description                     = "The Admin password of the ACR"
  sensitive                       = true
}

