velero install --provider azure --plugins velero/velero-plugin-for-microsoft-azure:v1.4.0 --bucket velero --secret-file velerocredstfmodified --backup-location-config resourceGroup="rsgk8sbck",storageAccount="stk8sbck" --use-volume-snapshots=true --snapshot-location-config apiTimeout=5m,resourceGroup="rsgk8sbck",subscriptionId="16e85b36-5c9d-48cc-a45d-c672a4393c36"


velero backup create <backupname> --include-namespaces <namespace_name>