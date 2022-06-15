az aks create --name restoreaks2 -g rsgk8sbck --snapshot-id (az aks nodepool snapshot list -g rsgk8sbck | jq .[0].id)

az aks nodepool add --name np2 -g rsgk8sbck --cluster-name restoreaks2 --snapshot-id (az aks nodepool snapshot list -g rsgk8sbck | jq .[1].id)