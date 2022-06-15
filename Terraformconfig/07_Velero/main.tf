######################################################################
# Access to terraform
######################################################################

terraform {
  
  backend "azurerm" {}
  required_providers {
    azurerm               = {}
    kubernetes            = {}
    helm                  = {}
  }
}

provider "azurerm" {
  subscription_id         = var.AzureSubscriptionID
  client_id               = var.AzureClientID
  client_secret           = var.AzureClientSecret
  tenant_id               = var.AzureTenantID

  features {

    resource_group {
    
      prevent_deletion_if_contains_resources = false
    
    }

  }
}



######################################################################
# Creating a storage for Velero

# Creating the Resource Group

module "ResourceGroup" {
  
  #Module Location
  source                                  = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/003_ResourceGroup/"
  #Module variable      
  RGSuffix                                = var.ResourcesSuffix
  RGLocation                              = var.RGLocation
  DefaultTags                             = var.DefaultTags

}




module "STA" {

  #Module Location
  source                                = "github.com/dfrappart/Terra-AZModuletest/Modules_building_blocks/101_StorageAccountGP"
  #Module variable    
  STASuffix                             = var.ResourcesSuffix
  RGName                                = module.ResourceGroup.RGName
  StorageAccountLocation                = var.RGLocation
  DefaultTags                           = var.DefaultTags
  LawLogId                              = data.azurerm_log_analytics_workspace.LAWLog.id
  STALogId                              = data.azurerm_storage_account.STALog.id
  STANTWRuleDefaultAction               = "Allow"

}


# Creating the STC

module "STCVelero" {

  #Module Location
  source                                = "github.com/dfrappart/Terra-AZModuletest//Modules_building_blocks/102_StorageAccountContainer"
  #Module variable    
  StorageContainerName                  = "velero"
  StorageAccountName                    = module.STA.Name



}


resource "local_file" "velerocreds" {
  content                                 = templatefile("./template/velero.tpl",
    {
      targetSub                           = data.azurerm_subscription.current.subscription_id
      AADTenantId                         = data.azurerm_subscription.current.tenant_id
      ClientId                            = var.AzureClientID
      clientSecret                        = var.AzureClientSecret
      AKSRG                               = data.terraform_remote_state.AKSClus.outputs.AKSNodeRG
      
    }
  )
  filename = "./velerocredstfmodified"
#
    provisioner "local-exec" {
        command = "bat.exe ${local_file.velerocreds.filename}"
    }
#
#    provisioner "local-exec" {
#        command = "velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.1.0 --bucket ${module.STCVelero.Name} --secret-file ${local_file.velerocreds.filename} --backup-location-config resourceGroup=${module.ResourceGroup.RGName},storageAccount=${module.STA.Name} --use-volume-snapshots=true --snapshot-location-config apiTimeout=5m,resourceGroup=${module.ResourceGroup.RGName},subscriptionId=${data.azurerm_subscription.current.subscription_id}"
#    }
}


resource "null_resource" "velero_install" {

#  provisioner "local-exec" {
#      command = "velero version --client-only"
#  }

  provisioner "local-exec" {
      command = "velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.4.0 --bucket ${module.STCVelero.Name} --secret-file velerocredstfmodified --backup-location-config resourceGroup=${module.ResourceGroup.RGName},storageAccount=${module.STA.Name} --use-volume-snapshots=true --snapshot-location-config apiTimeout=5m,resourceGroup=${module.ResourceGroup.RGName},subscriptionId=${data.azurerm_subscription.current.subscription_id}"
  }

  depends_on = [
    local_file.velerocreds
  ]
}
