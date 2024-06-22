namespace Own.Core.Azure;

using Own.Core.Logging;
using System.Utilities;
using Own.Core.Security;
using Own.Core.Helpers;

codeunit 50004 "CORE Azure FileShare Helper"
{
    #region Get Files
    procedure GetFile(CurrentFileShare: enum "CORE File Share"; Directory: Text; Filename: Text; var TempBlob: Codeunit "Temp Blob"): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        TechnicalLoggingHelper: Codeunit "CORE Technical Logging Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        FileHttpClient: HttpClient;
        Headers: HttpHeaders;
        FileHttpRequestMessage: HttpRequestMessage;
        FileHttpResponseMessage: HttpResponseMessage;
        GetFileInstream: InStream;
        GetFileOutStream: OutStream;
        ResponseAsText: Text;
        RequestFailedErr: Label 'Request failed with status code %1', Comment = '%1 = Status Code';
        AzureFileShareLbl: Label 'Azure File Share %1\%2', Comment = '%1 = Storage Account, %2 = File Share';
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        FileHttpRequestMessage.GetHeaders(Headers);
        FileHttpRequestMessage.Method('GET');

        FileHttpRequestMessage.SetRequestUri(StrSubstNo(GetFileUrlTxt, StorageAccount, FileShare, Directory, Filename, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');

        FileHttpClient.Send(FileHttpRequestMessage, FileHttpResponseMessage);

        if not FileHttpResponseMessage.IsSuccessStatusCode() then begin
            FileHttpResponseMessage.Content.ReadAs(ResponseAsText);
            TechnicalLoggingHelper.LogError(StrSubstNo(AzureFileShareLbl, StorageAccount, FileShare), 'GET File: ' + Filename + ' from Directory: ' + Directory,
                                   StrSubstNo(RequestFailedErr, FileHttpResponseMessage.HttpStatusCode()), FileHttpResponseMessage.HttpStatusCode(), ResponseAsText, "CORE Logging Level"::Error);
            exit(false);
        end;

        FileHttpResponseMessage.Content().ReadAs(GetFileInstream);

        TempBlob.CreateOutStream(GetFileOutStream);
        CopyStream(GetFileOutStream, GetFileInstream);

        exit(true);
    end;
    #endregion Get Files

    #region Uploading
    procedure Upload(CurrentFileShare: enum "CORE File Share"; Directory: Text; FileName: Text; TempBlob: Codeunit "Temp Blob"): Boolean
    var
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        ProgressHelper.InitProgressBar('Uploaden ' + FileName + '...', Round(TempBlob.Length() / 1024, 0.01, '='));

        if not CreateFile(CurrentFileShare, Directory, FileName, TempBlob) then
            exit(false);

        UpdateFile(CurrentFileShare, Directory, FileName, TempBlob);

        ProgressHelper.Close();

        exit(true);
    end;

    local procedure CreateFile(CurrentFileShare: enum "CORE File Share"; Directory: Text; FileName: Text; TempBlob: Codeunit "Temp Blob"): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        FileHttpClient: HttpClient;
        Headers: HttpHeaders;
        FileHttpRequestMessage: HttpRequestMessage;
        FileHttpResponseMessage: HttpResponseMessage;
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        FileHttpRequestMessage.GetHeaders(Headers);
        FileHttpRequestMessage.Method('PUT');

        if Directory <> '' then
            FileHttpRequestMessage.SetRequestUri(StrSubstNo(CreateUrlWithPathTxt, StorageAccount, FileShare, Directory, FileName, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)))
        else
            FileHttpRequestMessage.SetRequestUri(StrSubstNo(CreateUrlTxt, StorageAccount, FileShare, FileName, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');
        Headers.TryAddWithoutValidation('x-ms-type', 'File');
        Headers.TryAddWithoutValidation('x-ms-content-length', Format(TempBlob.Length()));

        FileHttpClient.Send(FileHttpRequestMessage, FileHttpResponseMessage);
        if not FileHttpResponseMessage.IsSuccessStatusCode() then
            exit(false);

        exit(true);
    end;

    local procedure UpdateFile(CurrentFileShare: enum "CORE File Share"; Directory: Text; FileName: Text; TempBlob: Codeunit "Temp Blob")
    var
        RangeTempBlob: Codeunit "Temp Blob";
        FileByte: Byte;
        FileInStream: InStream;
        Bytes: Integer;
        RangeOutstream: OutStream;
        Ranges: Integer;
        Range: Integer;
        TotalBytes: Integer;
        BytesRead: Integer;
    begin
        TotalBytes := TempBlob.Length(); //Max 2GB?
        BytesRead := 0;

        TempBlob.CreateInStream(FileInStream);

        if TotalBytes <= 500000 then
            UploadRange(CurrentFileShare, Directory, FileName, TempBlob, TotalBytes)
        else begin
            Ranges := Round(TotalBytes / 500000, 1, '>');
            for Range := 1 to Ranges do begin
                Clear(RangeTempBlob);
                RangeTempBlob.CreateOutStream(RangeOutstream);

                for Bytes := 0 to 499999 do
                    if BytesRead >= TotalBytes then
                        break
                    else begin
                        FileInStream.Read(FileByte, 1);
                        RangeOutstream.Write(FileByte);

                        BytesRead += 1;
                    end;

                if RangeTempBlob.Length() > 0 then begin
                    ProgressHelper.UpdateProgressBar('Uploaden ' + FileName + '...', Round((BytesRead / 1024), 0.01, '='));
                    UploadRange(CurrentFileShare, Directory, FileName, RangeTempBlob, BytesRead);
                end;
            end;
        end;
    end;

    local procedure UploadRange(CurrentFileShare: enum "CORE File Share"; Directory: Text; FileName: Text; TempBlob: Codeunit "Temp Blob"; EndByte: Integer)
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        FileHttpClient: HttpClient;
        FileHttpContent: HttpContent;
        Headers: HttpHeaders;
        FileHttpRequestMessage: HttpRequestMessage;
        FileHttpResponseMessage: HttpResponseMessage;
        RangeInstream: InStream;
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        TempBlob.CreateInStream(RangeInstream);
        FileHttpContent.WriteFrom(RangeInstream);

        FileHttpRequestMessage.GetHeaders(Headers);
        FileHttpRequestMessage.Method('PUT');
        if Directory <> '' then
            FileHttpRequestMessage.SetRequestUri(StrSubstNo(UpdateUrlWithPathTxt, StorageAccount, FileShare, Directory, FileName, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)))
        else
            FileHttpRequestMessage.SetRequestUri(StrSubstNo(UpdateUrlTxt, StorageAccount, FileShare, FileName, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        FileHttpRequestMessage.Content(FileHttpContent);

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');
        Headers.TryAddWithoutValidation('x-ms-write', 'update');
        Headers.TryAddWithoutValidation('x-ms-date', 'now');
        Headers.TryAddWithoutValidation('x-ms-range', 'bytes=' + Format(EndByte - TempBlob.Length()) + '-' + Format(EndByte - 1));
        Headers.TryAddWithoutValidation('Content-Length', Format(TempBlob.Length()));

        FileHttpClient.Send(FileHttpRequestMessage, FileHttpResponseMessage);
    end;
    #endregion Uploading

    #region Directories
    procedure DirectoryExists(CurrentFileShare: enum "CORE File Share"; Directory: Text): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        DirectoryHttpClient: HttpClient;
        Headers: HttpHeaders;
        DirectoryHttpRequestMessage: HttpRequestMessage;
        DirectoryHttpResponseMessage: HttpResponseMessage;
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        DirectoryHttpRequestMessage.GetHeaders(Headers);
        DirectoryHttpRequestMessage.Method('GET');

        DirectoryHttpRequestMessage.SetRequestUri(StrSubstNo(GetDirectoryUrlTxt, StorageAccount, FileShare, Directory, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');

        DirectoryHttpClient.Send(DirectoryHttpRequestMessage, DirectoryHttpResponseMessage);
        exit(DirectoryHttpResponseMessage.IsSuccessStatusCode());
    end;

    procedure CreateDirectory(CurrentFileShare: enum "CORE File Share"; Directory: Text): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        DirectoryHttpClient: HttpClient;
        Headers: HttpHeaders;
        DirectoryHttpRequestMessage: HttpRequestMessage;
        DirectoryHttpResponseMessage: HttpResponseMessage;
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        DirectoryHttpRequestMessage.GetHeaders(Headers);
        DirectoryHttpRequestMessage.Method('PUT');
        DirectoryHttpRequestMessage.SetRequestUri(StrSubstNo(CreateDirectoryUrlTxt, StorageAccount, FileShare, Directory, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');

        DirectoryHttpClient.Send(DirectoryHttpRequestMessage, DirectoryHttpResponseMessage);
        exit(DirectoryHttpResponseMessage.IsSuccessStatusCode());
    end;
    #endregion Directories

    #region Delete
    procedure Delete(CurrentFileShare: enum "CORE File Share"; Directory: Text; FileName: Text): Boolean
    var
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        FileHttpClient: HttpClient;
        Headers: HttpHeaders;
        FileHttpRequestMessage: HttpRequestMessage;
        FileHttpResponseMessage: HttpResponseMessage;
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        FileHttpRequestMessage.GetHeaders(Headers);
        FileHttpRequestMessage.Method('DELETE');

        FileHttpRequestMessage.SetRequestUri(StrSubstNo(CreateUrlWithPathTxt, StorageAccount, FileShare, Directory, FileName, KeyVaultHelper.GetSecretFromKeyVault(KeyVaultSecretName)));

        Headers.Clear();
        Headers.TryAddWithoutValidation('x-ms-version', '2018-03-28');

        FileHttpClient.Send(FileHttpRequestMessage, FileHttpResponseMessage);
        if not FileHttpResponseMessage.IsSuccessStatusCode() then
            exit(false);

        exit(true);
    end;
    #endregion Delete

    procedure GetUNCPath(CurrentFileShare: enum "CORE File Share"; Directory: Text; Filename: Text): Text
    var
        IFileShareSettings: Interface "CORE Azure File Share Settings";
        PathPlaceholderWithDirectoryLbl: Label '\\%1.file.core.windows.net\%2\%3\%4', Locked = true, Comment = '%1=The account name,%2=The file share,%3=The directory,%4=The filename';
        PathPlaceholderWithoutDirectoryLbl: Label '\\%1.file.core.windows.net\%2\%3', Locked = true, Comment = '%1=The account name,%2=The file share,%3=The filename';
        FileShare: Text;
        StorageAccount: Text;
        KeyVaultSecretName: Text;
    begin
        IFileShareSettings := CurrentFileShare;
        IFileShareSettings.SetStorageInformation(FileShare, StorageAccount, KeyVaultSecretName);

        if Directory <> '' then
            exit(StrSubstNo(PathPlaceholderWithDirectoryLbl, StorageAccount, FileShare, Directory.Replace('/', '\'), Filename))
        else
            exit(StrSubstNo(PathPlaceholderWithoutDirectoryLbl, StorageAccount, FileShare, Filename))
    end;

    var
        ProgressHelper: Codeunit "CORE Progress Bar Helper";
        GetFileUrlTxt: Label 'https://%1.file.core.windows.net/%2/%3/%4?%5', Comment = '%1=Account name,%2=Share name,%3=The path,%4=Filename,%5=SAS token', Locked = true;
        UpdateUrlWithPathTxt: Label 'https://%1.file.core.windows.net/%2/%3/%4?%5&comp=range', Comment = '%1=Account name,%2=Share name,%4=File name,%3=The path%5=SAS token', Locked = true;
        CreateUrlWithPathTxt: Label 'https://%1.file.core.windows.net/%2/%3/%4?%5', Comment = '%1=Account name,%2=Share name,%4=File name,%3=The path%5=SAS token', Locked = true;
        UpdateUrlTxt: Label 'https://%1.file.core.windows.net/%2/%3?%4&comp=range', Comment = '%1=Account name,%2=Share name,%3=File name,%4=SAS token', Locked = true;
        CreateUrlTxt: Label 'https://%1.file.core.windows.net/%2/%3?%4', Comment = '%1=Account name,%2=Share name,%3=File name,%4=SAS token', Locked = true;
        CreateDirectoryUrlTxt: Label 'https://%1.file.core.windows.net/%2/%3?%4&restype=directory', Comment = '%1=Account name,%2=Share name,%3=Directory name,%4=SAS token', Locked = true;
        GetDirectoryUrlTxt: Label 'https://%1.file.core.windows.net/%2/%3?%4&restype=directory', Comment = '%1=Account name,%2=Share name,%3=Directory name,%4=SAS token', Locked = true;
}