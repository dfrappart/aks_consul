######################################################
# Subscription Output

output "CurrentSubFullOutput" {

  value             = data.azurerm_subscription.current
}


######################################################
# Output for the AKS module with RBAC enabled

output "FullAKS" {
  value             = module.AKS1.FullAKS
  sensitive         = true
}


output "AKSNodeRG" {
  value             = module.AKS1.FullAKS.node_resource_group
  sensitive         = true
}

output "KubeName" {
  value             = module.AKS1.KubeName
}

output "KubeLocation" {
  value             = module.AKS1.KubeLocation
}

output "KubeRG" {
  value             = module.AKS1.KubeRG
}

output "KubeVersion" {
  value             = module.AKS1.KubeVersion
}


output "KubeId" {
  value             = module.AKS1.KubeId
  sensitive         = true       
}


output "KubeFQDN" {
  value             = module.AKS1.KubeFQDN
}

output "KubeAdminCFGRaw" {
  value             = module.AKS1.KubeAdminCFGRaw
  sensitive         = true
}


output "KubeAdminCFG" {
  value             = module.AKS1.KubeAdminCFG
  sensitive         = true
}

output "KubeAdminCFG_UserName" {
  value             = module.AKS1.KubeAdminCFG_UserName
  sensitive         = true
}

output "KubeAdminCFG_HostName" {
  value             = module.AKS1.KubeAdminCFG_HostName
  sensitive         = true
}


output "KubeAdminCFG_Password" {
  sensitive         = true
  value             = module.AKS1.KubeAdminCFG_Password
}


output "KubeAdminCFG_ClientKey" {
  sensitive         = true
  value             = module.AKS1.KubeAdminCFG_ClientKey
}


output "KubeAdminCFG_ClientCertificate" {
  sensitive         = true
  value             = module.AKS1.KubeAdminCFG_ClientCertificate
}

output "KubeAdminCFG_ClusCACert" {
  sensitive         = true
  value             = module.AKS1.KubeAdminCFG_ClusCACert
}


output "KubeControlPlane_SAI" {
  sensitive         = true
  value             = module.AKS1.KubeControlPlane_SAI
}

output "KubeControlPlane_SAI_PrincipalId" {
  sensitive         = true
  value             = module.AKS1.KubeControlPlane_SAI_PrincipalId
}

output "KubeControlPlane_SAI_TenantId" {
  sensitive         = true
  value             = module.AKS1.KubeControlPlane_SAI_TenantId
}

output "KubeKubelet_UAI" {
  sensitive         = true
  value             = module.AKS1.KubeKubelet_UAI
}

output "KubeKubelet_UAI_ClientId" {
  sensitive         = true
  value             = module.AKS1.KubeKubelet_UAI_ClientId
}

output "KubeKubelet_UAI_ObjectId" {
  sensitive         = true
  value             = module.AKS1.KubeKubelet_UAI_ObjectId
}

output "KubeKubelet_UAI_Id" {
  sensitive         = true
  value             = module.AKS1.KubeKubelet_UAI_Id
}

output "Kube_AddonsOMS" {
  sensitive         = true
  value             = module.AKS1.FullAKS.oms_agent[0].oms_agent_identity[0].object_id
}




