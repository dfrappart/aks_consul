##############################################################
#This module allows the creation of an AKS cluster
##############################################################


#Output for the AKS module with RBAC enabled

output "AKSNPName" {
  value                                     = azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool.name
}

output "AKSNPId" {
  value                                     = azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool.id
}

output "AKSNP_OSType" {
  value                                     = azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool.os_type
}

output "AKSNP_VMSize" {
  value                                     = azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool.vm_size
}

output "AKSNP_Version" {
  value                                     = azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool.orchestrator_version
}