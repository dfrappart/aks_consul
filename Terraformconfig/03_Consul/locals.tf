

locals {
    HelmAzureServiceOperatorParam = {
        "set1" = {
            ParamName             = "azureSubscription"
            ParamValue            = var.AzureSubscriptionID


        }

        "set2" = {
            ParamName             = "azureTenantID"
            ParamValue            = var.AzureTenantID


        }

        "set3" = {
            ParamName             = "azureClientID"
            ParamValue            = var.AzureClientID


        }

        "set4" = {
            ParamName             = "azureClientSecret"
            ParamValue            = var.AzureClientSecret


        }
    }
}