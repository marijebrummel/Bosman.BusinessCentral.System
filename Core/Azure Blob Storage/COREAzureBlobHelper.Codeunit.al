namespace Own.Core.Azure;

using System.Azure.Storage;
using System.IO;
using Own.Core.Logging;
using Own.Core.Security;
using Own.Core.Helpers;

codeunit 50007 "CORE Azure Blob Helper"
{
    procedure Put(CurrentContainer: Enum "CORE Container"; InS: InStream; Filename: Text): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        TechnicalLoggingHelper: Codeunit "CORE Technical Logging Helper";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        MemoryStream: Codeunit "MemoryStream Wrapper";
        ABSResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        IAzureBlobSettings: Interface "CORE Azure Blob Settings";
        FileHttpClient: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        FileHttpResponseMessage: HttpResponseMessage;
        Container: Text;
        AccountName: Text;
        AuthMethod: Option " ","SAS Token","Shared Access Key";
        Token: Text;
        Lenght: Integer;
        ResponseAsText: Text;
    begin
        IAzureBlobSettings := CurrentContainer;
        IAzureBlobSettings.SetStorageInformation(Container, AccountName, Token, AuthMethod);

        if AuthMethod = AuthMethod::"Shared Access Key" then begin
            Authorization := StorageServiceAuthorization.CreateSharedKey(KeyVaultHelper.GetSecretFromKeyVault(Token));
            ABSBlobClient.Initialize(AccountName, Container, Authorization);
            ABSResponse := ABSBlobClient.PutBlobBlockBlobStream(Filename, InS);
            if ABSResponse.IsSuccessful() then
                exit(true)
            else begin
                TechnicalLoggingHelper.LogError('Azure Blob', 'PUT', ABSResponse.GetError(), 0, "CORE Logging Level"::Informational);
                exit(false);
            end;
        end;

        if AuthMethod = AuthMethod::"SAS Token" then begin
            FileHttpClient.SetBaseAddress(StrSubstNo(BlobBaseURLLbl, AccountName));

            MemoryStream.Create(0);
            MemoryStream.ReadFrom(InS);
            Lenght := MemoryStream.Length();
            MemoryStream.SetPosition(0);
            MemoryStream.GetInStream(InS);

            Content.WriteFrom(InS);
            Content.GetHeaders(Headers);
            Headers.Remove('Content-Type');
            Headers.Add('Content-Type', 'application/octet-stream');
            Headers.Add('Content-Length', Format(Lenght)); //StrSubstNo('%1', len));
            Headers.Add('x-ms-blob-type', 'BlockBlob');

            if FileHttpClient.Put(StrSubstNo(BlobURLLbl, AccountName, Container, Filename, KeyVaultHelper.GetSecretFromKeyVault(Token)), Content, FileHttpResponseMessage) then
                if FileHttpResponseMessage.IsSuccessStatusCode() then
                    exit(true)
                else begin
                    FileHttpResponseMessage.Content.ReadAs(ResponseAsText);
                    TechnicalLoggingHelper.LogError('Azure Blob', 'PUT', ResponseAsText, FileHttpResponseMessage.HttpStatusCode(), "CORE Logging Level"::Informational);
                    exit(false);
                end
            else
                TechnicalLoggingHelper.LogError('Azure Blob', 'PUT', UnexpectedErr, FileHttpResponseMessage.HttpStatusCode(), "CORE Logging Level"::Informational);
        end;

        exit(false);
    end;

    procedure Download(CurrentContainer: Enum "CORE Container"; FullFileName: Text; var InStr: InStream)
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
        IAzureBlobSettings: Interface "CORE Azure Blob Settings";
        Response: HttpResponseMessage;
        Client: HttpClient;
        Container: Text;
        AccountName: Text;
        AuthMethod: Option " ","SAS Token","Shared Access Key";
        Token: Text;
    begin
        IAzureBlobSettings := CurrentContainer;
        IAzureBlobSettings.SetStorageInformation(Container, AccountName, Token, AuthMethod);

        if AuthMethod = AuthMethod::"Shared Access Key" then begin
            Authorization := StorageServiceAuthorization.CreateSharedKey(KeyVaultHelper.GetSecretFromKeyVault(Token));
            ABSBlobClient.Initialize(AccountName, Container, Authorization);
            ABSBlobClient.GetBlobAsStream(FullFileName, InStr);
        end;

        if AuthMethod = AuthMethod::"SAS Token" then
            if Client.Get(StrSubstNo(BlobURLLbl, AccountName, Container, FullFileName, KeyVaultHelper.GetSecretFromKeyVault(Token)), Response) then
                Response.Content().ReadAs(InStr);
    end;

    procedure Delete(CurrentContainer: Enum "CORE Container"; FullFileName: Text)
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
        IAzureBlobSettings: Interface "CORE Azure Blob Settings";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Container: Text;
        AccountName: Text;
        AuthMethod: Option " ","SAS Token","Shared Access Key";
        Token: Text;
    begin
        IAzureBlobSettings := CurrentContainer;
        IAzureBlobSettings.SetStorageInformation(Container, AccountName, Token, AuthMethod);

        if AuthMethod = AuthMethod::"Shared Access Key" then begin
            Authorization := StorageServiceAuthorization.CreateSharedKey(KeyVaultHelper.GetSecretFromKeyVault(Token));
            ABSBlobClient.Initialize(AccountName, Container, Authorization);
            ABSBlobClient.DeleteBlob(FullFileName);
        end;

        if AuthMethod = AuthMethod::"SAS Token" then
            Client.Delete(StrSubstNo(BlobURLLbl, AccountName, Container, FullFileName, KeyVaultHelper.GetSecretFromKeyVault(Token)), Response);
    end;

    [Obsolete('Replaced by procedure Download(CurrentContainer: enum "CORE Container"; FullFileName: Text; var InStr: InStream)')]
    procedure Download(DownloadRequestBody: JsonObject): JsonToken
    var
        APIProvider: enum "CORE API Provider";
        StatusCode: Integer;
    begin
        exit(APIHelper.Post(APIProvider::"BC Connect", '/api/azurestorage/download', DownloadRequestBody, StatusCode));
    end;

    [Obsolete('Replaced by procedure Put(CurrentContainer: enum "CORE Container"; InS: InStream; Filename: Text): Boolean')]
    procedure Upload(UploadRequestBody: JsonObject; var StatusCode: Integer): JsonToken
    var
        APIProvider: enum "CORE API Provider";
    begin
        exit(APIHelper.Post(APIProvider::"BC Connect", '/api/azurestorage/upload', UploadRequestBody, StatusCode));
    end;

    procedure Delete(DeleteRequestBody: JsonObject; var StatusCode: Integer): JsonToken
    var
        APIProvider: enum "CORE API Provider";
    begin
        exit(APIHelper.Post(APIProvider::"BC Connect", '/api/azurestorage/delete', DeleteRequestBody, StatusCode));
    end;

    procedure CreateDownloadRequest(FileName: Text; ConnectionString: Text; ContainerName: Text; FileExtension: Text; DeletaAfterImport: Boolean; MoveAfterImport: Boolean; MoveToContainerName: Text): JsonObject
    var
        FileNameList: List of [Text];
        FileExtensionList: List of [Text];
    begin
        FileNameList.Add(FileName);
        FileExtensionList.Add(FileExtension);

        exit(CreateDownloadRequest(FileNameList, ConnectionString, ContainerName, FileExtensionList, DeletaAfterImport, MoveAfterImport, MoveToContainerName));
    end;

    procedure CreateDownloadRequest(FileNameList: List of [Text]; ConnectionString: Text; ContainerName: Text; FileExtensionList: List of [Text]; DeletaAfterImport: Boolean; MoveAfterImport: Boolean; MoveToContainerName: Text): JsonObject
    var
        DownloadRequest: JsonObject;
        FileName: Text;
        FileExtension: Text;
        FileNames: JsonArray;
        FileExtensions: JsonArray;
    begin
        foreach FileName in FileNameList do
            FileNames.Add(FileName);

        foreach FileExtension in FileExtensionList do
            FileExtensions.Add(FileExtension);

        JSONHelper.AddValue(DownloadRequest, 'connectionString', ConnectionString);
        JSONHelper.AddValue(DownloadRequest, 'containerName', ContainerName);
        JSONHelper.AddValue(DownloadRequest, 'deleteFileAfterDownload', DeletaAfterImport);
        JSONHelper.AddValue(DownloadRequest, 'moveFileAfterDownload', MoveAfterImport);
        JSONHelper.AddValue(DownloadRequest, 'moveFileToContainer', MoveToContainerName);

        JSONHelper.Add(DownloadRequest, 'fileNameList', FileNames);
        JSONHelper.Add(DownloadRequest, 'fileExtensionList', FileExtensions);

        exit(DownloadRequest);
    end;

    procedure CreateUploadRequest(Base64Content: Text; FileName: Text; ConnectionString: Text; ContainerName: Text; AccessType: Integer; OverwriteExisting: Boolean): JsonObject
    var
        UploadRequest: JsonObject;
    begin
        JSONHelper.AddValue(UploadRequest, 'connectionString', ConnectionString);
        JSONHelper.AddValue(UploadRequest, 'containerName', ContainerName);
        JSONHelper.AddValue(UploadRequest, 'fileName', FileName);
        JSONHelper.AddValue(UploadRequest, 'containerPublicAccessType', AccessType);
        JSONHelper.AddValue(UploadRequest, 'base64Content', Base64Content);
        JSONHelper.AddValue(UploadRequest, 'overWriteExisting', OverwriteExisting);
        JSONHelper.AddValue(UploadRequest, 'externalUrl', '');

        exit(UploadRequest);
    end;

    procedure CreateDeleteRequest(FileName: Text; ConnectionString: Text; ContainerName: Text): JsonObject
    var
        DeleteRequest: JsonObject;
    begin
        JSONHelper.AddValue(DeleteRequest, 'connectionString', ConnectionString);
        JSONHelper.AddValue(DeleteRequest, 'containerName', ContainerName);
        JSONHelper.AddValue(DeleteRequest, 'filename', FileName);

        exit(DeleteRequest);
    end;

    var
        APIHelper: Codeunit "CORE API Helper";
        JSONHelper: Codeunit "CORE JSON Helper";
        BlobBaseURLLbl: Label 'https://%1.blob.core.windows.net', Comment = '%1 = Account Name', Locked = true;
        BlobURLLbl: Label 'https://%1.blob.core.windows.net/%2/%3?%4', Comment = '%1 = Account Name, %2 = Container, %3 = Filename, %4 = SASToken', Locked = true;
        UnexpectedErr: Label 'Unexpected error while connecting to the API.';
}
