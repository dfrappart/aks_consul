######################################################################
# config variables 
######################################################################






Project                             = "consul"
Environment                         = "lab"

ResourcesSuffix                     = "consul"
ResourceGroupSuffixList             = ["spkaks","aks"]

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
    CostCenter                      = "labtf"
    Project                         = "consul"
    Environment                     = "lab"
    ManagedBy                       = "Terraform"

  }