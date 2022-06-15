##############################################
#Variable for using subscription setup state as a data source

variable "SubsetupSTOAName" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "SubsetupContainerName" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "SubsetupKey" {
  type    = string
  description = "The storage access key of the storage account"
}

variable "SubsetupAccessKey" {
  type    = string
  description = "The state file name for the subsetup state"
}

##############################################
#Variable for using infra state as a data source

variable "InfrasetupSTOAName" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "InfraSetupContainerName" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "InfraSetupAccessKey" {
  type    = string
  description = "he storage access key of the storage account"
}

variable "InfraSetupKey" {
  type    = string
  description = "the name of the file containing the state of the 02 Azure Autmation setup configuration"
}

##############################################
#Variable for using AKS state as a data source

variable "AKSSetupSTOAName" {
  type    = string
  description = "the name of the storage account storing the state of the 02 automation setup configuration"
}

variable "AKSSetupContainerName" {
  type    = string
  description = "The name of the container in which the state is stored"
}

variable "AKSSetupAccessKey" {
  type    = string
  description = "The storage access key of the storage account"
}

variable "AKSSetupKey" {
  type    = string
  description = "The state file name for the aks state"
}

######################################################
# variables for Azure resources

variable "RGLocation" {
  type          = string
  description   = "Liocation in which resources are deployed"
  default       = "eastus"

}


variable "ResourcesSuffix" {
  type          = string
  description   = "resource dsuffix to add at the end of the resource name"
  default       = "k8sbck"

}

variable "DefaultTags" {

  description                           = "Define a set of default tags"
  
}

variable "ExtraTags" {
  type                                  = map
  description                           = "Define a set of additional optional tags."
  default                               = {}
}

##############################################################
#Variable declaration for provider azure

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