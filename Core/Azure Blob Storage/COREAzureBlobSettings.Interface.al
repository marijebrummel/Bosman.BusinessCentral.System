namespace Own.Core.Azure;

interface "CORE Azure Blob Settings"
{
    procedure SetStorageInformation(var Container: Text; var StorageAccount: Text; var TokenKVName: Text; var AuthMethod: Option " ","SAS Token","Shared Access Key")
}