##############################################################
#This module allows the creation of an ACR
##############################################################

##############################################################
#Variable declaration for Module

##############################################################
# Log variables section

#The Name of the FW

variable "STALogId" {
  type                    = string
  description             = "Specifies the id of the storage account used for logs."

}

variable "LawLogId" {
  type                    = string
  description             = "Specifies the id of the log analytics workspace used for logs."

}

#The Container Registry Name
variable "stringlenght" {
  type          = string
  description   = "Define the length of the random suffix"
  default       = 5 

}

#The Container Registry Name
variable "ACRSuffix" {
  type          = string
  description   = "A suffix for the ACR"
  default       = ""

}

#The RG containing the ACR
variable "ACRRG" {
  type          = string
  description   = "The RG containing the ACR"

}

#The ACR Location
variable "ACRLocation" {
  type    = string
  description = "The ACR Location"

}

#This variable determines if the admin account is enabled on the ACR or not, ture of false
variable "IsAdminEnabled" {
  type          = string
  description   = "This variable determines if the admin account is enabled on the ACR or not, ture of false"
  default       = false

}


#This variable determines the Sku of the ACR. Allowed values are basic, standard & premium
variable "ACRSku" {
  type          = string
  default       = "Premium"
  description   = "This variable determines the Sku of the ACR. Allowed values are basic, standard & premium"
    
  

}

#The list of Region for replication of the ACR
variable "ACRReplList" {
  type                      = map(object({
    Location                = string
    ZoneRedundancyEnabled   = bool

  }))
  default                   = {

    "Region1"               = {
      Location                = "westeurope"
      ZoneRedundancyEnabled   = true      
    }

  }
  description   = "A map to feed the dynamic block georeplications"

}


######################################################
#Tag related variables and naming convention section

variable "DefaultTags" {

  description                           = "Define a set of default tags"
  default                               = {
    ResourceOwner                       = "That would be me"
    Country                             = "fr"
    CostCenter                          = "labtf"
    Project                             = "aks"
    Environment                         = "lab"
    ManagedBy                           = "Terraform"

  }
  
}

variable "ExtraTags" {
  type                                  = map
  description                           = "Define a set of additional optional tags."
  default                               = {}
}

######################################################
#ACR association

variable "IsACRAssociatedtoAKSCluster" {
  type          = bool
  default       = false
  description   = "a boolean used to activate the association of the acr with an AKS cluster kubelet identity"
   
}

variable "AKSKubeletPrincipalId" {
  type          = string
  default       = ""
  description   = "The principal Id of AKS Kubelet to associated with the registry"
   
}

#####################################################
# diagnostic settings variable

variable "logcategories" {
  type                                  = map
  description                           = "A map used to feed the dynamic blocks of the gw configuration"
  default                               = {

      "logcat1"                         = {
        LogCatName                      = "ContainerRegistryRepositoryEvents"
        IsLogCatEnabled                 = true
        IsRetentionEnabled              = true
        RetentionDay                    = 365
    }

      "logcat2"                         = {
        LogCatName                      = "ContainerRegistryLoginEvents"
        IsLogCatEnabled                 = true
        IsRetentionEnabled              = true
        RetentionDay                    = 365
    } 

  }
}