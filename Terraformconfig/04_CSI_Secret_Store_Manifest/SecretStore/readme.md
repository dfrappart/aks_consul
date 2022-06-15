# Folder SecretStore

This folder is used as a target for the creation of yaml manifest for Secret Store. The following file is used as a template:

```yaml

apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: azure-kvname
spec:
  provider: azure
  parameters:
    usePodIdentity: "true"               
    userAssignedIdentityID: ${UAIClientId}
    keyvaultName: ${KVName}
    cloudName: ""                               
    objects:  |
      array:
        - |
          objectName: ${SecretName}
          objectAlias: ${SecretName}            
          objectType: secret                    
          objectVersion: ${SecretVersion}       
    tenantId: ${TenantId}  

```

Using the local_file resource as below, we generate the files in this folder. However, those file are not added in git:

```bash

resource "local_file" "secretprovider1" {
  content                                 = templatefile("./secretprovider-template.yaml",
    {
      UAIClientId                         = module.UAI1.ClientId,
      KVName                              = module.AKSKeyVault.Name
      SecretName                          = module.SecretTest_to_KV.SecretFullOutput.name
      SecretVersion                       = ""
      TenantId                            = data.azurerm_subscription.current.tenant_id
    }
  )
  filename = "../02_PodIdentity_Yaml/SecretStore/${lower(module.AKSKeyVault.Name)}-secretstore.yaml"
}

```
