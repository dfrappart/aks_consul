######################################################################
# config variables 
######################################################################






Project                             = "consul"
Environment                         = "lab"

ResourcesSuffix                     = "consul"
ResourceGroupSuffixList             = ["spkaks","aks","data"]

SpokeVnetConfig                     = {
    "Spoke1"                        = {
        VNetAddressSpace            = "172.23.0.0/16"
        VNetSuffix                  = "spkaks"
        IsBastionEnabled            = false
        IsVMDeployed                = false

    }
}

DefaultTags                         = {
    ResourceOwner                   = "That would be me"
    Country                         = "fr"
    CostCenter                      = "labconsul"
    Project                         = "consul"
    Environment                     = "lab"
    ManagedBy                       = "Terraform"

  }

MSSQLADAdminObjectId                = "546e2d3b-450e-4049-8f9c-423e1da3444c"

MSSQLDBThreatDetectionPolicyEmail   = ["david@teknews.cloud"]

AzureRegion                         = "eastus"
MSSQLAcceptAzureService             = true