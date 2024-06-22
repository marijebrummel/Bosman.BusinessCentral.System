namespace Own.Core.FTP;

using Own.Core.Logging;
using Own.Core.Security;
using Own.Core.Helpers;
using System.Utilities;
using Own.Core.Setup;

codeunit 50013 "CORE FTP Helper"
{
    procedure Upload(FTPSettings: Record "CORE FTP Settings"; Base64Content: Text; FileName: Text): Boolean
    var
        FTPNotification: Notification;
        Response: JsonToken;
        RequestBody: JsonObject;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
        ResponseAsText: Text;
        ServiceLbl: Label 'FTP - %1', Comment = '%1 = FTPSetting."No."';
        ErrorMessageLbl: Label '%1 - FTP Upload Error', Comment = '%1 = FileName';
    begin
        RequestBody := CreateUploadRequest(FTPSettings, Base64Content, FileName);
        Response := APIHelper.Post(APIProvider::"BC Connect", '/api/ftp/upload', RequestBody, StatusCode);

        if Response.AsObject().Contains('successful') then
            if JSONHelper.GetBooleanValue(Response, 'successful') then
                exit(true)
            else begin
                Response.WriteTo(ResponseAsText);
                LoggingHelper.LogError(StrSubstNo(ServiceLbl, FTPSettings."No."), '/api/FTP/Upload', StrSubstNo(ErrorMessageLbl, FileName), StatusCode, ResponseAsText, Enum::"CORE Logging Level"::Error);
                if GuiAllowed() then begin
                    FTPNotification.Scope(NotificationScope::LocalScope);
                    FTPNotification.Message(ResponseAsText);
                    FTPNotification.Send();
                end;
                exit(false);
            end;
        exit(false);
    end;

    procedure Download(FTPSettings: Record "CORE FTP Settings"; FileNameList: List of [Text]; FileExtensionList: List of [Text]): JsonToken
    var
        Response: JsonToken;
        RequestBody: JsonObject;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
    begin
        RequestBody := CreateDownloadRequest(FTPSettings, FileExtensionList, FileExtensionList);
        Response := APIHelper.Post(APIProvider::"BC Connect", '/api/ftp/download', RequestBody, StatusCode);
        exit(Response);
    end;

    procedure DownloadXML(FTPSettings: Record "CORE FTP Settings"; FileName: Text): XmlDocument
    var
        Response: JsonToken;
        RequestBody: JsonObject;
        XMLData: XmlDocument;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
        FileNameList: List of [Text];
        FileExtensionList: List of [Text];
        Base64Content: Text;
        FileNameEmptyErr: Label 'FileName cannot be empty when downloading the XML contents of one single file.';
    begin
        if FileName = '' then
            Error(FileNameEmptyErr);
        FileNameList.Add(FileName);
        FileExtensionList.Add('.xml');
        RequestBody := CreateDownloadRequest(FTPSettings, FileExtensionList, FileExtensionList);
        Response := APIHelper.Post(APIProvider::"BC Connect", '/api/ftp/download', RequestBody, StatusCode);
        if Response.AsObject().Contains('base64Content') then begin
            Base64Content := JSONHelper.GetTextValue(Response, 'base64Content');
            if XmlDocument.ReadFrom(Base64Content, XMLData) then
                exit(XMLData);
        end;
    end;

    procedure DownloadJSON(FTPSettings: Record "CORE FTP Settings"; FileName: Text): JsonToken
    var
        Response: JsonToken;
        RequestBody: JsonObject;
        JsonData: JsonToken;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
        FileNameList: List of [Text];
        FileExtensionList: List of [Text];
        Base64Content: Text;
        FileNameEmptyErr: Label 'FileName cannot be empty when downloading the JSON contents of one single file.';
    begin
        if FileName = '' then
            Error(FileNameEmptyErr);
        FileNameList.Add(FileName);
        FileExtensionList.Add('.json');
        RequestBody := CreateDownloadRequest(FTPSettings, FileExtensionList, FileExtensionList);
        Response := APIHelper.Post(APIProvider::"BC Connect", '/api/ftp/download', RequestBody, StatusCode);
        if Response.AsObject().Contains('base64Content') then begin
            Base64Content := JSONHelper.GetTextValue(Response, 'base64Content');
            if JsonData.ReadFrom(Base64Content) then
                exit(JsonData);
        end;
    end;

    local procedure CreateUploadRequest(FTPSettings: Record "CORE FTP Settings"; Base64Content: Text; FileName: Text): JsonObject
    var
        Setup: Record "CORE Setup";
        RequestBody: JsonObject;
        Host: JsonObject;
        Credentials: JsonObject;
    begin
        if not Setup.Get() then
            exit;

        Setup.TestField("BC Connect API Base URL");
        Setup.TestField("BC Connect Api Key KV Name");

        JSONHelper.AddValue(Host, 'hostName', FTPSettings.Host);
        if FTPSettings.Type = FTPSettings.Type::"FTP(S)" then
            JSONHelper.AddValue(Host, 'useSsl', true);
        if FTPSettings.Type = FTPSettings.Type::SFTP then
            JSONHelper.AddValue(Host, 'useSsh', true);

        JSONHelper.Add(RequestBody, 'host', Host);

        JSONHelper.AddValue(Credentials, 'userName', KeyVaultHelper.GetSecretFromKeyVault(FTPSettings."User Name KV Name"));
        JSONHelper.AddValue(Credentials, 'password', KeyVaultHelper.GetSecretFromKeyVault(FTPSettings."Password KV Name"));

        JSONHelper.Add(RequestBody, 'credentials', Credentials);

        if FTPSettings."Remote Path Upload" <> '' then
            JSONHelper.AddValue(RequestBody, 'remotePath', FTPSettings."Remote Path Upload");
        JSONHelper.AddValue(RequestBody, 'fileName', FileName);
        JSONHelper.AddValue(RequestBody, 'base64Content', Base64Content);
        JSONHelper.AddValue(RequestBody, 'overwriteExisting', FTPSettings."Overwrite Existing");

        exit(RequestBody);
    end;

    local procedure CreateDownloadRequest(FTPSettings: Record "CORE FTP Settings"; FileNameList: List of [Text]; FileExtensionList: List of [Text]): JsonObject
    var
        Setup: Record "CORE Setup";
        FileNames: JsonArray;
        FileExtensions: JsonArray;
        Host: JsonObject;
        Credentials: JsonObject;
        RequestBody: JsonObject;
        FileName: Text;
        FileExtension: Text;
    begin
        if not Setup.Get() then
            exit;

        Setup.TestField("BC Connect API Base URL");
        Setup.TestField("BC Connect Api Key KV Name");

        JSONHelper.AddValue(Host, 'hostName', FTPSettings.Host);
        if FTPSettings.Type = FTPSettings.Type::"FTP(S)" then
            JSONHelper.AddValue(Host, 'useSsl', true);
        if FTPSettings.Type = FTPSettings.Type::SFTP then
            JSONHelper.AddValue(Host, 'useSsh', true);

        JSONHelper.Add(RequestBody, 'host', Host);

        JSONHelper.AddValue(Credentials, 'userName', KeyVaultHelper.GetSecretFromKeyVault(FTPSettings."User Name KV Name"));
        JSONHelper.AddValue(Credentials, 'password', KeyVaultHelper.GetSecretFromKeyVault(FTPSettings."Password KV Name"));

        JSONHelper.Add(RequestBody, 'credentials', Credentials);

        if FTPSettings."Remote Path Download" <> '' then
            JSONHelper.AddValue(RequestBody, 'remotePath', FTPSettings."Remote Path Download");

        foreach FileName in FileNameList do
            FileNames.Add(FileName);

        foreach FileExtension in FileExtensionList do
            FileExtensions.Add(FileExtension);

        JSONHelper.Add(RequestBody, 'fileNames', FileNames);
        JSONHelper.Add(RequestBody, 'fileExtensions', FileExtensions);

        JSONHelper.AddValue(RequestBody, 'deleteAfterDownload', FTPSettings."Delete After Download");
        JSONHelper.AddValue(RequestBody, 'moveAfterDownload', FTPSettings."Move After Download");
        JSONHelper.AddValue(RequestBody, 'moveToPath', FTPSettings."Remote Path Move To");

        exit(RequestBody);
    end;

    var
        APIHelper: Codeunit "CORE API Helper";
        JSONHelper: Codeunit "CORE JSON Helper";
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
        LoggingHelper: Codeunit "CORE Technical Logging Helper";
}
