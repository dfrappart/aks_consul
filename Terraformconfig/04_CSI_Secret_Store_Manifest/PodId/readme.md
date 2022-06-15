# Folder PodId

This folder is used as a target for the creation of yaml manifest for pod identity. Using the module KubeUAI, we ca get a yaml manifest as an output such as this:

```powershell

PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\01_Infra> terraform output UAI1_podidentitybindingmanifest
<<EOT
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: uailab1-binding
spec:
  azureIdentity: uailab1
  selector: uailab1-binding
EOT

PS C:\Users\AKSMeetup_CSI_Secret_Store\Terraformconfig\01_Infra> terraform output UAI1_podidentitymanifest
<<EOT
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: uailab1
spec:
  type: 0
  resourceID: /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsglabmeetup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uailab1
  clientID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
EOT

```

Using hte local_file resource as below, we generate the files in this folder. However, those file are not added in git:

```bash

resource "local_file" "podidentitymanifest" {
  content                                 = module.UAI1.podidentitymanifest
  filename                                = "../02_PodIdentity_Yaml/PodId/${module.UAI1.Name}.yaml"
}

resource "local_file" "podidentitybindingmanifest" {
  content                                 = module.UAI1.podidentitybindingmanifest
  filename                                = "../02_PodIdentity_Yaml/PodId/${module.UAI1.Name}_Binding.yaml"
}

```
