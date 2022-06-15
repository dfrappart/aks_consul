# CSI Secret store demo

deploy the pod identity and its binding in kubernetes:

```powershell
C:\Users\davidfrappart\Documents\IaC\Azure\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest\PodId
PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest\PodId> kubectl apply -f .\PodId\uailab1.yaml      
azureidentity.aadpodidentity.k8s.io/uailab1 created
PS C:\Users\Documents\IaC\Azure\AKSPodIdMeetup\02_PodIdentity_Yaml> kubectl apply -f .\PodId\uailab1_Binding.yaml
azureidentitybinding.aadpodidentity.k8s.io/uailab1-binding created
PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest\PodId>

```

Afterward, we need to install a secret store which refers to an existing keyvault. This secret store is created througha yaml manifest like this:

```yaml

apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: ${SecretProviderClassName}
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

This file is generated with the proper value in the 01_Infra folder with a local_file resource:

```bash

resource "local_file" "secretprovider" {
  count                                   = 2
  content                                 = templatefile("./yamltemplate/secretprovider-template.yaml",
    {
      SecretProviderClassName             = "${data.azurerm_key_vault.aks_agw_keyvault.name}${module.UAI_AKS_CSI[count.index].Name}"
      UAIClientId                         = module.UAI_AKS_CSI[count.index].ClientId
      KVName                              = data.azurerm_key_vault.aks_agw_keyvault.name
      SecretName                          = module.SecretTest_to_KV[count.index].SecretFullOutput.name
      SecretVersion                       = ""
      TenantId                            = data.azurerm_subscription.current.tenant_id
    }
  )
  filename = "../04_CSI_Secret_Store_Manifest/SecretStore/${lower(data.azurerm_key_vault.aks_agw_keyvault.name)}${count.index+1}-podid-secretstore.yaml"
}

```

Once the secret store is also created, it is time to try it with a pod on which the secret is mounted, again from a template yaml:

```yaml

apiVersion: v1
kind: Pod
metadata:
  name: ${PodName}
spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:
        - name: secrets-store-inline
          mountPath: "/mnt/secrets-store"
          readOnly: true
  volumes:
    - name: secrets-store-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: ${SecretProviderClassName}

```

And afterward created from a localfile resource:

```bash

resource "local_file" "podexample" {
  count                                   = 2
  content                                 = templatefile("./yamltemplate/TestPod-template.yaml",
    {
      PodName                             = "pod-${data.azurerm_key_vault.aks_agw_keyvault.name}${module.UAI_AKS_CSI[count.index].Name}"
      SecretProviderClassName             = "${data.azurerm_key_vault.aks_agw_keyvault.name}${module.UAI_AKS_CSI[count.index].Name}"
    }
  )
  filename = "../04_CSI_Secret_Store_Manifest/demo-pod${count.index+1}.yaml"
}

```

Get the pod info status:

```powershell

PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest> kubectl describe pods nginx-secrets-store-inline 
Name:         nginx-secrets-store-inline
Namespace:    default
Priority:     0
Node:         aks-aksnp0terraa-28115117-vmss000002/172.20.0.134
Start Time:   Sun, 07 Feb 2021 21:52:37 +0100
Labels:       aadpodidbinding=uailab1-binding
Annotations:  cni.projectcalico.org/podIP: 10.244.1.9/32
Status:       Running
IP:           10.244.1.9
IPs:
  IP:  10.244.1.9
Containers:
  nginx:
    Container ID:   docker://6059d3f5ea325674fdd612b41dd68103794037a7b8d6c5b4c26372abbf68ccc2
    Image:          nginx
    Image ID:       docker-pullable://nginx@sha256:10b8cc432d56da8b61b070f4c7d2543a9ed17c2b23010b43af434fd40e2ca4aa
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sun, 07 Feb 2021 21:53:28 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /mnt/secrets-store from secrets-store-inline (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-gdr98 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  secrets-store-inline:
    Type:              CSI (a Container Storage Interface (CSI) volume source)
    Driver:            secrets-store.csi.k8s.io
    FSType:
    ReadOnly:          true
    VolumeAttributes:      secretProviderClass=azure-kvname
  default-token-gdr98:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-gdr98
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  15m   default-scheduler  Successfully assigned default/nginx-secrets-store-inline to aks-aksnp0terraa-28115117-vmss000002
  Normal  Pulling    14m   kubelet            Pulling image "nginx"
  Normal  Pulled     14m   kubelet            Successfully pulled image "nginx"
  Normal  Created    14m   kubelet            Created container nginx
  Normal  Started    14m   kubelet            Started container nginx


```

Everything seems alright, check the access to the keyvault:

```bash

PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest> kubectl exec nginx-secrets-store-inline -- ls /mnt/secrets-store
kvs-demo1
PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\04_CSI_Secret_Store_Manifest\PodId> kubectl exec nginx-secrets-store-inline -- cat /mnt/secrets-store/kvs-demo1
e&D}:6+<)fM!n=@!

```
