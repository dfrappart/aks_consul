## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster_node_pool.TerraAKSNodePool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AKSAZ"></a> [AKSAZ](#input\_AKSAZ) | The list of AZ to use | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_AKSClusterId"></a> [AKSClusterId](#input\_AKSClusterId) | The ID of the Kubernetes Cluster where this Node Pool should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_AKSMaxPods"></a> [AKSMaxPods](#input\_AKSMaxPods) | Define the max pod number per nodes, Change force new resoure to be created | `string` | `100` | no |
| <a name="input_AKSMaxSurge"></a> [AKSMaxSurge](#input\_AKSMaxSurge) | The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade. | `string` | `"33%"` | no |
| <a name="input_AKSNPPlacementGroup"></a> [AKSNPPlacementGroup](#input\_AKSNPPlacementGroup) | The ID of the Proximity Placement Group where the Virtual Machine Scale Set that powers this Node Pool will be placed. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_AKSNPPriority"></a> [AKSNPPriority](#input\_AKSNPPriority) | The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created. | `string` | `"Regular"` | no |
| <a name="input_AKSNodeCount"></a> [AKSNodeCount](#input\_AKSNodeCount) | The number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100. | `string` | `3` | no |
| <a name="input_AKSNodeInstanceType"></a> [AKSNodeInstanceType](#input\_AKSNodeInstanceType) | The type of Azure instance for the pool | `string` | `"Standard_D2S_v4"` | no |
| <a name="input_AKSNodeLabels"></a> [AKSNodeLabels](#input\_AKSNodeLabels) | A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created. | `map` | `null` | no |
| <a name="input_AKSNodeOSDiskSize"></a> [AKSNodeOSDiskSize](#input\_AKSNodeOSDiskSize) | The size of the OS Disk which should be used for each agent in the Node Pool. Changing this forces a new resource to be created. | `string` | `100` | no |
| <a name="input_AKSNodeOSDiskType"></a> [AKSNodeOSDiskType](#input\_AKSNodeOSDiskType) | The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_AKSNodeOSType"></a> [AKSNodeOSType](#input\_AKSNodeOSType) | he Operating System which should be used for this Node Pool. Changing this forces a new resource to be created. Possible values are Linux and Windows. Defaults to Linux. | `string` | `"Linux"` | no |
| <a name="input_AKSNodeTaints"></a> [AKSNodeTaints](#input\_AKSNodeTaints) | A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule). Changing this forces a new resource to be created. | `list` | `null` | no |
| <a name="input_AKSSubnetId"></a> [AKSSubnetId](#input\_AKSSubnetId) | The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_DefaultTags"></a> [DefaultTags](#input\_DefaultTags) | Define a set of default tags | `map` | <pre>{<br>  "CostCenter": "labtf",<br>  "Country": "fr",<br>  "Environment": "lab",<br>  "ManagedBy": "Terraform",<br>  "Project": "aks",<br>  "ResourceOwner": "That would be me"<br>}</pre> | no |
| <a name="input_EnableAKSAutoScale"></a> [EnableAKSAutoScale](#input\_EnableAKSAutoScale) | Is autoscaling enabled for this node pool | `string` | `true` | no |
| <a name="input_EnableHostEncryption"></a> [EnableHostEncryption](#input\_EnableHostEncryption) | Should the nodes in this Node Pool have host encryption enabled? Defaults to false. | `string` | `null` | no |
| <a name="input_EnableNodePublicIP"></a> [EnableNodePublicIP](#input\_EnableNodePublicIP) | Define if Nodes get Public IP. Defualt API value is false | `string` | `null` | no |
| <a name="input_EvictionPolicy"></a> [EvictionPolicy](#input\_EvictionPolicy) | The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are Deallocate and Delete. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_ExtraTags"></a> [ExtraTags](#input\_ExtraTags) | Define a set of additional optional tags. | `map` | `{}` | no |
| <a name="input_KubeVersion"></a> [KubeVersion](#input\_KubeVersion) | The version of Kube, used for Node pool version but also for Control plane version | `string` | `null` | no |
| <a name="input_KubeletAllowedUnsafeSysctls"></a> [KubeletAllowedUnsafeSysctls](#input\_KubeletAllowedUnsafeSysctls) | Specifies the allow list of unsafe sysctls command or patterns (ending in *). Changing this forces a new resource to be created. | `list(string)` | `null` | no |
| <a name="input_KubeletContainerLogMaxLine"></a> [KubeletContainerLogMaxLine](#input\_KubeletContainerLogMaxLine) | Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletContainerLogMaxSize"></a> [KubeletContainerLogMaxSize](#input\_KubeletContainerLogMaxSize) | Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletCpuCfsQuotaEnabled"></a> [KubeletCpuCfsQuotaEnabled](#input\_KubeletCpuCfsQuotaEnabled) | Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletCpuCfsQuotaPeriod"></a> [KubeletCpuCfsQuotaPeriod](#input\_KubeletCpuCfsQuotaPeriod) | Specifies the CPU CFS quota period value. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletCpuManagerPolicy"></a> [KubeletCpuManagerPolicy](#input\_KubeletCpuManagerPolicy) | Specifies the CPU Manager policy to use. Possible values are none and static, Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletImageGcHighThreshold"></a> [KubeletImageGcHighThreshold](#input\_KubeletImageGcHighThreshold) | Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletImageGcLowThreshold"></a> [KubeletImageGcLowThreshold](#input\_KubeletImageGcLowThreshold) | Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletPodMaxPid"></a> [KubeletPodMaxPid](#input\_KubeletPodMaxPid) | Specifies the maximum number of processes per pod. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_KubeletTopologyManagerPolicy"></a> [KubeletTopologyManagerPolicy](#input\_KubeletTopologyManagerPolicy) | Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_LinuxOSConfigSwapFileSize"></a> [LinuxOSConfigSwapFileSize](#input\_LinuxOSConfigSwapFileSize) | Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_LinuxOSConfigTransparentHugePageDefrag"></a> [LinuxOSConfigTransparentHugePageDefrag](#input\_LinuxOSConfigTransparentHugePageDefrag) | Specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_LinuxOSConfigTransparentHugePageEnabled"></a> [LinuxOSConfigTransparentHugePageEnabled](#input\_LinuxOSConfigTransparentHugePageEnabled) | Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_MaxAutoScaleCount"></a> [MaxAutoScaleCount](#input\_MaxAutoScaleCount) | The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100 | `string` | `10` | no |
| <a name="input_MinAutoScaleCount"></a> [MinAutoScaleCount](#input\_MinAutoScaleCount) | The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100. | `string` | `2` | no |
| <a name="input_NPMode"></a> [NPMode](#input\_NPMode) | Should this Node Pool be used for System or User resources? Possible values are System and User. Defaults to User. | `string` | `null` | no |
| <a name="input_NPSuffix"></a> [NPSuffix](#input\_NPSuffix) | An suffix to identify the node pool | `string` | n/a | yes |
| <a name="input_SysCtlFsAioMaxNr"></a> [SysCtlFsAioMaxNr](#input\_SysCtlFsAioMaxNr) | The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlFsFileMax"></a> [SysCtlFsFileMax](#input\_SysCtlFsFileMax) | The sysctl setting fs.file-max. Must be between 8192 and 12000500. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlFsInotifyMaxUserWatches"></a> [SysCtlFsInotifyMaxUserWatches](#input\_SysCtlFsInotifyMaxUserWatches) | The sysctl setting fs.inotify.max\_user\_watches. Must be between 781250 and 2097152. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlFsNrOpen"></a> [SysCtlFsNrOpen](#input\_SysCtlFsNrOpen) | The sysctl setting fs.nr\_open. Must be between 8192 and 20000500. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlKernelThreadsMax"></a> [SysCtlKernelThreadsMax](#input\_SysCtlKernelThreadsMax) | The sysctl setting kernel.threads-max. Must be between 20 and 513785. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreOptmemMax"></a> [SysCtlNetCoreOptmemMax](#input\_SysCtlNetCoreOptmemMax) | The sysctl setting net.core.optmem\_max. Must be between 20480 and 4194304. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreRmemDefault"></a> [SysCtlNetCoreRmemDefault](#input\_SysCtlNetCoreRmemDefault) | The sysctl setting net.core.rmem\_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreRmemMax"></a> [SysCtlNetCoreRmemMax](#input\_SysCtlNetCoreRmemMax) | The sysctl setting net.core.rmem\_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreSomaxconn"></a> [SysCtlNetCoreSomaxconn](#input\_SysCtlNetCoreSomaxconn) | The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreWmemDefault"></a> [SysCtlNetCoreWmemDefault](#input\_SysCtlNetCoreWmemDefault) | The sysctl setting net.core.wmem\_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoreWmemMax"></a> [SysCtlNetCoreWmemMax](#input\_SysCtlNetCoreWmemMax) | The sysctl setting net.core.wmem\_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetCoredevMaxBacklog"></a> [SysCtlNetCoredevMaxBacklog](#input\_SysCtlNetCoredevMaxBacklog) | The sysctl setting net.core.netdev\_max\_backlog. Must be between 1000 and 3240000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4IpLocalPortRangeMax"></a> [SysCtlNetIpv4IpLocalPortRangeMax](#input\_SysCtlNetIpv4IpLocalPortRangeMax) | The sysctl setting net.ipv4.ip\_local\_port\_range max value. Must be between 1024 and 60999. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4IpLocalPortRangeMin"></a> [SysCtlNetIpv4IpLocalPortRangeMin](#input\_SysCtlNetIpv4IpLocalPortRangeMin) | The sysctl setting net.ipv4.ip\_local\_port\_range min value. Must be between 1024 and 60999. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpFinTimeOut"></a> [SysCtlNetIpv4NTcpFinTimeOut](#input\_SysCtlNetIpv4NTcpFinTimeOut) | The sysctl setting net.ipv4.tcp\_fin\_timeout. Must be between 5 and 120. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpKeepAliveIntvl"></a> [SysCtlNetIpv4NTcpKeepAliveIntvl](#input\_SysCtlNetIpv4NTcpKeepAliveIntvl) | The sysctl setting net.ipv4.tcp\_keepalive\_intvl. Must be between 10 and 75. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpKeepAliveProbes"></a> [SysCtlNetIpv4NTcpKeepAliveProbes](#input\_SysCtlNetIpv4NTcpKeepAliveProbes) | The sysctl setting net.ipv4.tcp\_keepalive\_probes. Must be between 1 and 15. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpKeepAliveTime"></a> [SysCtlNetIpv4NTcpKeepAliveTime](#input\_SysCtlNetIpv4NTcpKeepAliveTime) | The sysctl setting net.ipv4.tcp\_keepalive\_time. Must be between 30 and 432000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpMaxSynBacklog"></a> [SysCtlNetIpv4NTcpMaxSynBacklog](#input\_SysCtlNetIpv4NTcpMaxSynBacklog) | The sysctl setting net.ipv4.tcp\_max\_syn\_backlog. Must be between 128 and 3240000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpMaxTwBuckets"></a> [SysCtlNetIpv4NTcpMaxTwBuckets](#input\_SysCtlNetIpv4NTcpMaxTwBuckets) | The sysctl setting net.ipv4.tcp\_max\_tw\_buckets. Must be between 8000 and 1440000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NTcpMaxTwReuse"></a> [SysCtlNetIpv4NTcpMaxTwReuse](#input\_SysCtlNetIpv4NTcpMaxTwReuse) | The sysctl setting net.ipv4.tcp\_tw\_reuse. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NeighDefaultGcThreshold1"></a> [SysCtlNetIpv4NeighDefaultGcThreshold1](#input\_SysCtlNetIpv4NeighDefaultGcThreshold1) | The sysctl setting net.ipv4.neigh.default.gc\_thresh1. Must be between 128 and 80000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NeighDefaultGcThreshold2"></a> [SysCtlNetIpv4NeighDefaultGcThreshold2](#input\_SysCtlNetIpv4NeighDefaultGcThreshold2) | The sysctl setting net.ipv4.neigh.default.gc\_thresh2. Must be between 512 and 90000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetIpv4NeighDefaultGcThreshold3"></a> [SysCtlNetIpv4NeighDefaultGcThreshold3](#input\_SysCtlNetIpv4NeighDefaultGcThreshold3) | The sysctl setting net.ipv4.neigh.default.gc\_thresh3. Must be between 512 and 90000. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetfilterNfConntrackBuckets"></a> [SysCtlNetfilterNfConntrackBuckets](#input\_SysCtlNetfilterNfConntrackBuckets) | The sysctl setting net.netfilter.nf\_conntrack\_max. Must be between 131072 and 589824. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlNetfilterNfConntrackMax"></a> [SysCtlNetfilterNfConntrackMax](#input\_SysCtlNetfilterNfConntrackMax) | The sysctl setting net.netfilter.nf\_conntrack\_max. Must be between 131072 and 589824. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlVmMaxMapCount"></a> [SysCtlVmMaxMapCount](#input\_SysCtlVmMaxMapCount) | The sysctl setting vm.max\_map\_count. Must be between 65530 and 262144. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlVmSwapiness"></a> [SysCtlVmSwapiness](#input\_SysCtlVmSwapiness) | The sysctl setting vm.swappiness. Must be between 0 and 100. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_SysCtlVmVfsCachePressure"></a> [SysCtlVmVfsCachePressure](#input\_SysCtlVmVfsCachePressure) | The sysctl setting vm.vfs\_cache\_pressure. Must be between 0 and 100. Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AKSNPId"></a> [AKSNPId](#output\_AKSNPId) | n/a |
| <a name="output_AKSNPName"></a> [AKSNPName](#output\_AKSNPName) | n/a |
| <a name="output_AKSNP_OSType"></a> [AKSNP\_OSType](#output\_AKSNP\_OSType) | n/a |
| <a name="output_AKSNP_VMSize"></a> [AKSNP\_VMSize](#output\_AKSNP\_VMSize) | n/a |
| <a name="output_AKSNP_Version"></a> [AKSNP\_Version](#output\_AKSNP\_Version) | n/a |
