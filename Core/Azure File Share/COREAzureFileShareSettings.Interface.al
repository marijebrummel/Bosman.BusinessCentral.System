namespace Own.Core.Azure;

interface "CORE Azure File Share Settings"
{
    procedure SetStorageInformation(var FileShare: Text; var StorageAccount: Text; var SasTokenKVName: Text)
}
