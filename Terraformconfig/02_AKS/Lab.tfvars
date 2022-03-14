######################################################################
# config variables 
######################################################################






IsAGICEnabled         = false
IsAKSPrivate          = false
AKSClusSuffix         = "consul"

AzureRegion                         = "swedencentral"

DefaultTags                         = {
    ResourceOwner                   = "That would be me"
    Country                         = "fr"
    CostCenter                      = "labtf"
    Project                         = "consul"
    Environment                     = "lab"
    ManagedBy                       = "Terraform"

  }

ACRReplList = {
  "Region1"               = {
      Location                = "westeurope"
      ZoneRedundancyEnabled   = true      
    }

  "Region2"               = {
      Location                = "northeurope"
      ZoneRedundancyEnabled   = true      
    }

}

AKSClusterAdminsIds                     = "546e2d3b-450e-4049-8f9c-423e1da3444c"
