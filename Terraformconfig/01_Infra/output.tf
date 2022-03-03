######################################################
# Subscription Output

output "CurrentSubFullOutput" {

  value             = data.azurerm_subscription.current
}

######################################################
#Resource Group ouputs

output "RG_Name" {

  value             = module.ResourceGroup[*].RGName
}

output "RG_Location" {

  value             = module.ResourceGroup[*].RGLocation
}

output "RG_Id" {

  value             = module.ResourceGroup[*].RGId
  sensitive         = true
}




######################################################
# Module VNet Outputs
######################################################

##############################################################
#Output for the VNet

output "VNet" {
  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].VNetFullOutput 
  }
  sensitive = true
}

output "VNetName" {
  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].VNetFullOutput.name 
  }
  sensitive = true
}

output "VNetId" {
  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].VNetFullOutput.id 
  }
  sensitive = true
}

output "VNetAddresSpace" {
  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].VNetFullOutput.address_space 
  }
  sensitive = true
}


##############################################################
# Subnet outputs



# Subnet AppGW

output "AGWSubnet_VNet_FullOutput" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].AGWSubnetFullOutput
  }
  sensitive         = true
}

output "AGWSubnet_VNet_Name" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].AGWSubnetFullOutput.name
  }
  sensitive         = true
}

output "AGWSubnet_VNet_AdressPrefixes" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].AGWSubnetFullOutput.address_prefixes
  }
  sensitive         = true
}
# Subnet FESubnet

output "FESubnet_VNet_FullOutput" {
  
  value             = {
    for k,v in var.SpokeVnetConfig : k=> module.SpokeVNet[k].FESubnetFullOutput
  }
  sensitive         = true
}


output "FESubnet_VNet_Name" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].FESubnetFullOutput.name
  }
  sensitive         = true
}

output "FESubnet_VNet_AdressPrefixes" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].FESubnetFullOutput.address_prefixes
  }
  sensitive         = true
}

# Subnet BESubnet

output "BESubnet_VNet_FullOutput" {
  
  value             = {
    for k,v in var.SpokeVnetConfig : k=> module.SpokeVNet[k].BESubnetFullOutput
  }
  sensitive         = true
}


output "BESubnet_VNet_Name" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].BESubnetFullOutput.name
  }
  sensitive         = true
}

output "BESubnet_VNet_AdressPrefixes" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].BESubnetFullOutput.address_prefixes
  }
  sensitive         = true
}

##############################################################
#Outout for IP Groups

output "IPGroups" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>azurerm_ip_group.VNetIPGroups[k]
  }
  sensitive         = true
}

output "IPGroupsCIDR" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>azurerm_ip_group.VNetIPGroups[k].cidrs
  }
  sensitive         = true
}

output "IPGroupsId" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>azurerm_ip_group.VNetIPGroups[k].id
  }
  sensitive         = true
}

output "IPGroupsName" {

  value = {
    for k,v in var.SpokeVnetConfig : k=>azurerm_ip_group.VNetIPGroups[k].name
  }
  sensitive         = true
}


##############################################################
#Outout for NSG

# NSG Bastion Subnet

output "AzureBastionNSG_VNet_Name" {
  value             = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].AzureBastionNSGName
  }
  sensitive         = false
}



# NSG AppGW Subnet

output "AGWSubnetNSG_VNet_FullOutput" {
  value             = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].AGWSubnetNSGFullOutput
  }
  sensitive         = true
}



# NSG FE Subnet

output "FESubnetNSG_VNet_FullOutput" {
  value             = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].FESubnetNSGFullOutput
  }
  sensitive         = true
}



# NSG BE Subnet

output "BESubnetNSG_VNet_FullOutput" {
  value             = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].BESubnetNSGFullOutput
  }
  sensitive         = true
}



##############################################################
#Output for Bastion Host

output "SpokeBastion_Name" {
  value             = {
    for k,v in var.SpokeVnetConfig : k=>module.SpokeVNet[k].SpokeBastionName
  }
  sensitive         = true
}

##############################################################
#Output for SQL Server

output "MSSQLServer_FullOutput" {
  value             = azurerm_mssql_server.SQLAppServer1
  sensitive         = true
}

output "MSSQLServer_PwdKvRef" {
  value             = module.MSSQLAdminPWD
  sensitive         = true
}

output "MSSQLServer_VNetRule" {
  value             = azurerm_mssql_virtual_network_rule.VNetRule-SQLAppServer1
  sensitive         = true
}

output "MSSQLServer_AuditPolicy" {
  value             = azurerm_mssql_server_extended_auditing_policy.SQLAppServer1_ExtendedAuditingPolicy
  sensitive         = true
}

output "MSSQLDB_FullOutput" {
  value             = azurerm_mssql_database.SQLDBMyDrivingDB
  sensitive         = true
}

output "MSSQLDB_AuditPolicy" {
  value             = azurerm_mssql_database_extended_auditing_policy.SQLDBMyDrivingDBExtendedAutitingPolicy
  sensitive         = true
}