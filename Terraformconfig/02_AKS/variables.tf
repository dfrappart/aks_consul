##############################################################
#Variable declaration for provider

variable "AzureSubscriptionID" {
  type                          = string
  description                   = "The subscription id for the authentication in the provider"
}

variable "AzureClientID" {
  type                          = string
  description                   = "The application Id, taken from Azure AD app registration"
}


variable "AzureClientSecret" {
  type                          = string
  description                   = "The Application secret"

}

variable "AzureTenantID" {
  type                          = string
  description                   = "The Azure AD tenant ID"
}

######################################################
# Common variables

variable "AzureRegion" {
  type                            = string
  description                     = "The Azure region for deployment"
  default                         = "westeurope"
}

variable "ResourceOwnerTag" {
  type                            = string
  description                     = "Tag describing the owner"
  default                         = "That would be me"
}

variable "CountryTag" {
  type                            = string
  description                     = "Tag describing the Country"
  default                         = "fr"
}

variable "CostCenterTag" {
  type                            = string
  description                     = "Tag describing the Cost Center"
  default                         = "labaks"
}

variable "Project" {
  type                            = string
  description                     = "The name of the project"
  default                         = "cnitest"
}

variable "Environment" {
  type                            = string
  description                     = "The environment, dev, prod..."
  default                         = "lab"
}


variable "DefaultTags" {

  description                           = "Define a set of default tags"
  
}

variable "ExtraTags" {
  type                                  = map
  description                           = "Define a set of additional optional tags."
  default                               = {}
}
variable "ResourcesSuffix" {
  type                            = string
  description                     = "The environment, dev, prod..."
  default                         = "cnitest"
}


variable "UAISuffix" {
  type                            = string
  description                     = "The environment, dev, prod..."
  default                         = "lab1"
}

variable "AKSClusSuffix" {
  type                          = string
  default                       = "cni"
  description                   = "A suffix to identify the cluster without breacking the naming convention"

}

variable "IsAKSPrivate" {
  type                          = bool
  default                       = true
  description                   = "Whether the AKS is private or not"
}

variable "PrivateClusterPublicFqdn" {
  type                          = string
  default                       = null
  description                   = "Whether the private AKS use a public FQDN or not"
}

variable "IsAGICEnabled" {
  type                          = bool
  default                       = false
  description                   = "Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?"
}

variable "AKSPrivDNSZoneId" {
  type                          = string
  default                       = "unspecified"
  description                   = "Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?"
}

variable "AGWId" {
  type                          = string
  default                       = null
  description                   = "The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster."
}

variable "AGWName" {
  type                          = string
  default                       = null
  description                   = "The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

variable "AGWSubnetCidr" {
  type                          = string
  default                       = null
  description                   = "The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

variable "AGWSubnetId" {
  type                          = string
  default                       = null
  description                   = "The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

######################################################
# Data sources variables



variable "SubsetupSTOAName" {
  type          = string
  description   = "Name of the storage account containing the remote state"
}

variable "SubsetupAccessKey" {
  type          = string
  description   = "Access Key of the storage account containing the remote state"
}

variable "SubsetupContainerName" {
  type          = string
  description   = "Name of the container in the storage account containing the remote state"
}

variable "SubsetupKey" {
  type          = string
  description   = "State key"
}

##############################################
#Variable for using AKS state as a data source

variable "statestoa" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "statecontainer" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "statestoakey" {
  type    = string
  description = "The storage access key of the storage account"
}

variable "statekeyInfraState" {
  type    = string
  description = "the name of the file containing the state of the 02 Azure Autmation setup configuration"
}

######################################################
# AKS variables

variable "AKSSSHKey" {
  type                            = string
  description                     = "The SSH PublicKey"
  default                         = "A_Default_Value_Because_I_Dont_want_to_delete_that" 

}

variable "AKSClusterAdminsIds" {
  type                          = string
  description                   = " A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
}

######################################################
# AKS KV Access policy variables

variable "Secretperms_AKSClusterAdmins_AccessPolicy" {
  type                            = list
  description                     = "The authorization on the secret for the Access policy"
  default                         = ["backup","purge","recover","restore","get","list","set","delete"]

}

variable "Certperms_AKSClusterAdmins_AccessPolicy" {
  type                            = list
  description                     = "The authorization on the secret for the Access policy"
  default                         = ["backup","deleteissuers","get","getissuers","listissuers","managecontacts","manageissuers","purge","recover","restore","setissuers","list","update", "create", "import", "delete"]

}

variable "Secretperms_UAI1_AccessPolicy" {
  type                            = list
  description                     = "The authorization on the secret for the Access policy"
  default                         = ["get","list"]

}

variable "KeyVaultSecretSuffix" {
  type                            = string
  description                     = "The kv secret suffix" #tfsec:ignore:general-secrets-no-plaintext-exposure
  default                         = "test1"

}

######################################################
# agw variable

variable "DefaultHostSiteName" {
  type                          = string
  description                   = "Name of the certtificate imported in AGW"
  default                       = "aks.teknews.cloud"
}

variable "DefaultSiteIdentifier" {
  type                          = string
  description                   = "a string to identify the site host "
  default                       = "aks-teknews-cloud"
}

######################################################
# agw variable

variable "AKSNodePoolConfig" {
  type = map(object({
    AKSNodeTaints                       = list(string)
    IsNodePoolDeployed                  = bool
  }))
  description                           = "A map to configure the NodePool"

  default = {
    "1" = {
      AKSNodeTaints = null
      IsNodePoolDeployed = true
    }
  }
}

######################################################
# ACR variable
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

variable "ACRReplList2" {
  type = list(string)
  default = ["westeurope","northeurope"]
}