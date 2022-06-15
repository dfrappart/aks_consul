##############################################################
#config output
##############################################################

output "CurrentSubId" {

  value             = data.azurerm_subscription.current.subscription_id
}


##############################################################
#Output for the RG

output "ResourceGroup_veleroName" {

  value                         = module.ResourceGroup.RGName
}

output "ResourceGroup_veleroLocation" {

  value                         = module.ResourceGroup.RGLocation
}

output "ResourceGroup_veleroId" {

  value                         = module.ResourceGroup.RGId
  sensitive                     = true
}

output "STAName" {
    value                       = module.STA.Name
    sensitive                   = true
}

output "STAId" {
    value                       = module.STA.Id
    sensitive                   = true
}

output "STAFull" {
    value                       = module.STA.STAFull
    sensitive                   = true
}


