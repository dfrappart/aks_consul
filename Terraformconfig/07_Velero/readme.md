# Recovery demo

## 1. Velero Demo

### 1.1. Install the client side on  windows

```bash

choco install velero

```


### 1.2. Install the server side on a Kubernetes cluster

```bash

velero install --provider azure \
                --plugins velero/velero-plugin-for-microsoft-azure:v1.4.0 \
                --bucket ${module.STCVelero.Name} \
                --secret-file velerocredstfmodified \
                --backup-location-config resourceGroup=${module.ResourceGroup.RGName},storageAccount=${module.STA.Name} \
                --use-volume-snapshots=true \
                --snapshot-location-config apiTimeout=5m,resourceGroup=${module.ResourceGroup.RGName},subscriptionId=${data.azurerm_subscription.current.subscription_id}

```

### 2.1. Backing up some stuff with velero

```bash

velero backup create demo-bck --include-namespaces default
Backup request "demo-bck" submitted successfully.
Run `velero backup describe demo-bck` or `velero backup logs demo-bck` for more details.

```

### 2.2. Check the backup

```bash

velero backup describe demo-bck
Name:         demo-bck
Namespace:    velero
Labels:       velero.io/storage-location=default
Annotations:  velero.io/source-cluster-k8s-gitversion=v1.22.6
              velero.io/source-cluster-k8s-major-version=1
              velero.io/source-cluster-k8s-minor-version=22

Phase:  Completed

Errors:    0
Warnings:  0

Namespaces:
  Included:  default
  Excluded:  <none>

Resources:
  Included:        *
  Excluded:        <none>
  Cluster-scoped:  auto

Label selector:  <none>

Storage Location:  default

Velero-Native Snapshot PVs:  auto

TTL:  720h0m0s

Hooks:  <none>

Backup Format Version:  1.1.0

Started:    2022-05-05 09:49:17 +0200 CEST
Completed:  2022-05-05 09:49:20 +0200 CEST

Expiration:  2022-06-04 09:49:17 +0200 CEST

Total items to be backed up:  72
Items backed up:              72

Velero-Native Snapshots: <none included>

```

### 2.3. Restore on the same cluster

```bash

velero backup get
NAME             STATUS            ERRORS   WARNINGS   CREATED                          EXPIRES   STORAGE LOCATION   SELECTOR
consul-backup    PartiallyFailed   3        0          2022-04-30 20:14:04 +0200 CEST   25d       default            <none>
consul-backup2   Completed         0        0          2022-04-30 20:38:56 +0200 CEST   25d       default            <none>
demo-bck         Completed         0        0          2022-05-05 09:49:17 +0200 CEST   29d       default            <none>
demoappbck       Completed         0        0          2022-05-05 15:56:04 +0200 CEST   29d       default            <none>
help             PartiallyFailed   3        0          2022-04-30 20:10:21 +0200 CEST   25d       default            <none>

velero restore create demorestore --from-backup demoappbck

Restore request "demorestore" submitted successfully.
Run `velero restore describe demorestore` or `velero restore logs demorestore` for more details.

velero restore describe demorestore
Name:         ←[1mdemorestore←[0m
Namespace:    velero
Labels:       <none>
Annotations:  <none>

Phase:                       ←[32mCompleted←[0m
Total items to be restored:  11
Items restored:              11

Started:    2022-05-05 16:06:58 +0200 CEST
Completed:  2022-05-05 16:07:00 +0200 CEST

Backup:  demoappbck

Namespaces:
  Included:  all namespaces found in the backup
  Excluded:  <none>

Resources:
  Included:        *
  Excluded:        nodes, events, events.events.k8s.io, backups.velero.io, restores.velero.io, resticrepositories.velero.io
  Cluster-scoped:  auto

Namespace mappings:  <none>

Label selector:  <none>

Restore PVs:  auto

Preserve Service NodePorts:  auto

```

## 2. NodePool snapshot

### 2.1. The commands to know

```bash

az aks nodepool list --cluster-name
                     --resource-group

```

```bash

az aks snapshot create --name
                       --nodepool-id
                       --resource-group
                       [--aks-custom-headers]
                       [--location]
                       [--no-wait]
                       [--tags]

```

### 2.2. example usage

Get the node pool id

```bash

az aks nodepool list --cluster-name aks-consul --resource-group rsg-consul-aks | jq .[0].id

"/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul/agentPools/aksnp0consul"

az aks nodepool list --cluster-name aks-consul --resource-group rsg-consul-aks | jq .[1].id

"/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul/agentPools/np1"

```

snapshot the node pool

```bash

az aks nodepool snapshot create --name demo3-defaultnodepool --nodepool-id "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul/agentPools/aksnp0consul" --resource-group rsg-consul-aks

{
  "creationData": {
    "sourceResourceId": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul/agentPools/aksnp0consul"
  },
  "enableFips": null,
  "id": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/snapshots/demo3-defaultnodepool",
  "kubernetesVersion": "1.22.6",
  "location": "westeurope",
  "name": "demo3-defaultnodepool",
  "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2022.04.05",
  "osSku": "Ubuntu",
  "osType": "Linux",
  "resourceGroup": "rsg-consul-aks",
  "snapshotType": "NodePool",
  "systemData": {
    "createdAt": "2022-05-05T08:43:27.224718+00:00",
    "createdBy": "david@teknews.cloud",
    "createdByType": "User",
    "lastModifiedAt": "2022-05-05T08:43:27.224718+00:00",
    "lastModifiedBy": "david@teknews.cloud",
    "lastModifiedByType": "User"
  },
  "tags": null,
  "type": "Microsoft.ContainerService/Snapshots",
  "vmSize": "standard_d2s_v4"
}

```

List the snapshots

```bash

az aks nodepool snapshot list -o table
The behavior of this command has been altered by the following extension: aks-preview
Name                   Location    ResourceGroup    NodeImageVersion                         KubernetesVersion    OsType    OsSku
---------------------  ----------  ---------------  ---------------------------------------  -------------------  --------  -------
demo1-defaultnodepool  westeurope  rsg-consul-aks   AKSUbuntu-1804gen2containerd-2022.04.05  1.22.6               Linux     Ubuntu
demo1-usernodepool     westeurope  rsg-consul-aks   AKSUbuntu-1804gen2containerd-2022.04.05  1.22.6               Linux     Ubuntu

```

### 2.3. Create cluster from nodepool snapshot

```bash

az aks nodepool snapshot list | jq .[0].id

"/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/snapshots/demo1-defaultnodepool"

az aks create --name restoreaks --resource-group restore --snapshot-id "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/snapshots/demo1-defaultnodepool"

{
  "aadProfile": null,
  "addonProfiles": null,
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "capacityReservationGroupId": null,
      "count": 3,
      "creationData": {
        "sourceResourceId": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/snapshots/demo1-defaultnodepool"
      },
      "enableAutoScaling": false,
      "enableEncryptionAtHost": false,
      "enableFips": false,
      "enableNodePublicIp": false,
      "enableUltraSsd": false,
      "gpuInstanceProfile": null,
      "hostGroupId": null,
      "kubeletConfig": null,
      "kubeletDiskType": "OS",
      "linuxOsConfig": null,
      "maxCount": null,
      "maxPods": 110,
      "messageOfTheDay": null,
      "minCount": null,
      "mode": "System",
      "name": "nodepool1",
      "nodeImageVersion": "AKSUbuntu-1804gen2containerd-2022.04.05",
      "nodeLabels": null,
      "nodePublicIpPrefixId": null,
      "nodeTaints": null,
      "orchestratorVersion": "1.22.6",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osSku": "Ubuntu",
      "osType": "Linux",
      "podSubnetId": null,
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleDownMode": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": null,
      "vmSize": "standard_d2s_v4",
      "vnetSubnetId": null,
      "workloadRuntime": "OCIContainer"
    }
  ],
  "apiServerAccessProfile": null,
  "autoScalerProfile": null,
  "autoUpgradeProfile": null,
  "azurePortalFqdn": "restoreaks-restore-16e85b-d9b68c66.portal.hcp.westeurope.azmk8s.io",
  "currentKubernetesVersion": "1.22.6",
  "disableLocalAccounts": false,
  "diskEncryptionSetId": null,
  "dnsPrefix": "restoreaks-restore-16e85b",
  "enableNamespaceResources": null,
  "enablePodSecurityPolicy": false,
  "enableRbac": true,
  "extendedLocation": null,
  "fqdn": "restoreaks-restore-16e85b-d9b68c66.hcp.westeurope.azmk8s.io",
  "fqdnSubdomain": null,
  "httpProxyConfig": null,
  "id": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/restore/providers/Microsoft.ContainerService/managedClusters/restoreaks",
  "identity": {
    "principalId": "18298a21-eb31-4206-92c9-39e123a1adcb",
    "tenantId": "e0c45235-95fe-4bd6-96ca-2d529f0ebde4",
    "type": "SystemAssigned",
    "userAssignedIdentities": null
  },
  "identityProfile": {
    "kubeletidentity": {
      "clientId": "c178b571-c046-435a-8d9b-22c3eeaa7c01",
      "objectId": "3a6da698-c091-4a32-a60b-7e584e4f59ba",
      "resourceId": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/MC_restore_restoreaks_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/restoreaks-agentpool"
    }
  },
  "kubernetesVersion": "1.22.6",
  "linuxProfile": {
    "adminUsername": "azureuser",
    "ssh": {
      "publicKeys": [
        {
          "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDz2Quzi1xZie+W2NxN4TA7gtR3FcY8G61S128gv3slRsKRNConhobflZduqLdmryoEVTOmUfNcRwHTdl1a5XYVKdZ2Wl5p6pveFea5tRzXRmlmCyNYriXFY4en+LRx3T79Xqq7AYXJhllEE1kkmFqfZ/NuFgT/3ElNQVCzgp/lyRnnNi8ADL5BxgjhbO4vewDvfU5HKYiJIH6GZUAH4kLpV7oA35frSQ3SNoEG5btP2iQ/Gtd/sMTFv+mmRTrsqZrHDcc4evNLtqqVfCK065KPSSK+2fj1Rp+GF2/C0finMmUVxoczQPsb1XNM6Y1+8Wtm4dDxGFREUapS4P0BKn/3"
        }
      ]
    }
  },
  "location": "westeurope",
  "maxAgentPools": 100,
  "name": "restoreaks",
  "networkProfile": {
    "dnsServiceIp": "10.0.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "ipFamilies": [
      "IPv4"
    ],
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIPs": [
        {
          "id": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/MC_restore_restoreaks_westeurope/providers/Microsoft.Network/publicIPAddresses/f830b3dc-669f-42bd-b077-696f4e936502",
          "resourceGroup": "MC_restore_restoreaks_westeurope"
        }
      ],
      "enableMultipleStandardLoadBalancers": null,
      "idleTimeoutInMinutes": null,
      "managedOutboundIPs": {
        "count": 1,
        "countIpv6": null
      },
      "outboundIPs": null,
      "outboundIpPrefixes": null
    },
    "loadBalancerSku": "Standard",
    "natGatewayProfile": null,
    "networkMode": null,
    "networkPlugin": "kubenet",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": "10.244.0.0/16",
    "podCidrs": [
      "10.244.0.0/16"
    ],
    "serviceCidr": "10.0.0.0/16",
    "serviceCidrs": [
      "10.0.0.0/16"
    ]
  },
  "nodeResourceGroup": "MC_restore_restoreaks_westeurope",
  "oidcIssuerProfile": {
    "enabled": false,
    "issuerUrl": null
  },
  "podIdentityProfile": null,
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "privateLinkResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "restore",
  "securityProfile": {
    "azureDefender": null,
    "azureKeyVaultKms": null
  },
  "servicePrincipalProfile": {
    "clientId": "msi",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "systemData": null,
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": null
}

```

### 2.4. Add nodepool to cluster from snapshot

```bash

az aks nodepool add --name np2 --cluster-name restoreaks --resource-group restore --snapshot-id "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/snapshots/demo1-usernodepool"

```

## 3. Full cluster snapshot (preview)

```bash

az aks snapshot create --name demo2-fullcluster --cluster-id "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul" -g rsg-consul-aks
The behavior of this command has been altered by the following extension: aks-preview
{
  "creationData": {
    "sourceResourceId": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourcegroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedClusters/aks-consul"
  },
  "id": "/subscriptions/16e85b36-5c9d-48cc-a45d-c672a4393c36/resourceGroups/rsg-consul-aks/providers/Microsoft.ContainerService/managedclustersnapshots/demo2-fullcluster",
  "location": "westeurope",
  "managedClusterPropertiesReadOnly": {
    "enableRbac": true,
    "kubernetesVersion": "1.22.6",
    "networkProfile": {
      "loadBalancerSku": "Standard",
      "networkMode": null,
      "networkPlugin": "kubenet",
      "networkPolicy": "calico"
    },
    "sku": {
      "name": "Basic",
      "tier": "Free"
    }
  },
  "name": "demo2-fullcluster",
  "resourceGroup": "rsg-consul-aks",
  "snapshotType": "ManagedCluster",
  "systemData": {
    "createdAt": "2022-05-05T09:31:25.305189+00:00",
    "createdBy": "david@teknews.cloud",
    "createdByType": "User",
    "lastModifiedAt": "2022-05-05T09:31:25.305189+00:00",
    "lastModifiedBy": "david@teknews.cloud",
    "lastModifiedByType": "User"
  },
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusterSnapshots"
}


```

List cluster snapshot

```bash

az aks snapshot list -o table

Name               Location    ResourceGroup    Sku    EnableRbac    KubernetesVersion    NetworkPlugin    NetworkPolicy    LoadBalancerSku
-----------------  ----------  ---------------  -----  ------------  -------------------  ---------------  ---------------  -----------------
demo1-fullcluster  westeurope  rsg-consul-aks   Free   True          1.22.6               kubenet          calico           Standard
demo2-fullcluster  westeurope  rsg-consul-aks   Free   True          1.22.6               kubenet          calico           Standard

```



