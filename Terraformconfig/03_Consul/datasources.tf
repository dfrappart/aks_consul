#############################################################################
#This file is used to define data source refering to Azure existing resources
#############################################################################

#############################################################################
#data sources


data "azurerm_subscription" "current" {}

data "azurerm_client_config" "currentclientconfig" {}




#############################################################################
#data source for subscription setup logs features



data "terraform_remote_state" "Subsetupstate" {
  backend                     = "azurerm"
  config                      = {
    storage_account_name      = var.SubsetupSTOAName
    container_name            = var.SubsetupContainerName
    key                       = var.SubsetupKey
    access_key                = var.SubsetupAccessKey
  }
}

#############################################################################
#data source for infra


#Data source for remote state

data "terraform_remote_state" "Infra" {
  backend   = "azurerm"
  config    = {
    storage_account_name = var.statestoa
    container_name       = var.statecontainer
    key                  = var.statekeyInfraState
    access_key           = var.statestoakey
  }
}


data "azurerm_resource_group" "InfraRG" {
  name                  = element(data.terraform_remote_state.Infra.outputs.RG_Name,0)
}

data "azurerm_resource_group" "AKSRG" {
  name                  = element(data.terraform_remote_state.Infra.outputs.RG_Name,1)
}

data "azurerm_virtual_network" "AKSVnet" {
  name                  = lookup(data.terraform_remote_state.Infra.outputs.VNetName,"Spoke1")
  resource_group_name   = data.azurerm_resource_group.InfraRG.name
}

data "azurerm_subnet" "fesubnet" {
  name                  = lookup(data.terraform_remote_state.Infra.outputs.FESubnet_VNet_Name,"Spoke1")
  virtual_network_name  = data.azurerm_virtual_network.AKSVnet.name
  resource_group_name   = data.azurerm_resource_group.InfraRG.name
}

data "azurerm_subnet" "besubnet" {
  name                  = lookup(data.terraform_remote_state.Infra.outputs.BESubnet_VNet_Name,"Spoke1")
  virtual_network_name  = data.azurerm_virtual_network.AKSVnet.name
  resource_group_name   = data.azurerm_resource_group.InfraRG.name
}

data "azurerm_subnet" "agwsubnet" {
  name                  = lookup(data.terraform_remote_state.Infra.outputs.AGWSubnet_VNet_Name,"Spoke1")
  virtual_network_name  = data.azurerm_virtual_network.AKSVnet.name
  resource_group_name   = data.azurerm_resource_group.InfraRG.name
}

#############################################################################
#data source for AKS


#Data source for remote state

data "terraform_remote_state" "AKSClus" {
  backend   = "azurerm"
  config    = {
    storage_account_name = var.statestoa
    container_name       = var.statecontainer
    key                  = var.statekeyAKSClusState
    access_key           = var.statestoakey
  }
}



data "azurerm_kubernetes_cluster" "AKSCluster" {
  name                  = data.terraform_remote_state.AKSClus.outputs.FullAKS.name
  resource_group_name   = data.azurerm_resource_group.AKSRG.name
}