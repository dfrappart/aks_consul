
# AKS Node Pool module

This module allows the deployment of an AKS Node Pool

## Exemple configuration

Deploy the following to have a new AKS Node Pool:

```hcl


######################################################################
# Module for AKS Node Pool

module "AKS_NodePool" {
  #Module Location
  source                                  = "../../Modules/IaaS_AKS_NodePool/"

  #Module variable

  NPIndex                                 = 1
  AKSClusterName                          = module.AKS1.KubeName
  AKSClusterId                            = module.AKS1.KubeId
  AKSNodeInstanceType                     = var.AKSNodeInstanceType
  AKSSubnetId                             = data.azurerm_subnet.AKSSubnet.id
  ResourceOwnerTag                        = var.ResourceOwnerTag
  CountryTag                              = var.CountryTag
  CostCenterTag                           = var.CostCenterTag
  EntityTag                               = var.EntityTag
  SectionAnalyticTag                      = var.SectionAnalyticTag
  Company                                 = var.Company
  Project                                 = var.Project
  Environment                             = var.Environment

}

```
