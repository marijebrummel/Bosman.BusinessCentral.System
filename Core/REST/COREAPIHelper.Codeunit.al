namespace Own.Core.Helpers;

using Own.Core.Logging;

codeunit 50000 "CORE API Helper"
{
    #region Methods
    procedure Get(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'GET', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Get(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'GET', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonObject; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Post(APIProvider, Path, JsonContent.AsToken(), HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonObject; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Post(APIProvider, Path, JsonContent.AsToken(), HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonToken; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'POST', Path, JsonContent, true, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonToken; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'POST', Path, JsonContent, true, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'POST', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Post(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'POST', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Put(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonToken; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'PUT', Path, JsonContent, true, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Put(APIProvider: Enum "CORE API Provider"; Path: Text; JsonContent: JsonToken; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'PUT', Path, JsonContent, true, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Put(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'PUT', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Put(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'PUT', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Delete(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer): JsonToken
    var
        ErrorEntryNo: Integer;
    begin
        exit(Execute(APIProvider, 'DELETE', Path, HttpStatusCode, ErrorEntryNo));
    end;

    procedure Delete(APIProvider: Enum "CORE API Provider"; Path: Text; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    begin
        exit(Execute(APIProvider, 'DELETE', Path, HttpStatusCode, ErrorEntryNo));
    end;

    #endregion Methods

    local procedure Execute(APIProvider: Enum "CORE API Provider"; Method: Text; Path: Text; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    var
        DummyContent: JsonToken;
    begin
        exit(Execute(APIProvider, Method, Path, DummyContent, false, HttpStatusCode, ErrorEntryNo));
    end;

    local procedure Execute(APIProvider: Enum "CORE API Provider"; Method: Text; Path: Text; JsonContent: JsonToken; HasRequestContent: Boolean; var HttpStatusCode: Integer; var ErrorEntryNo: Integer): JsonToken
    var
        JSONHelper: Codeunit "CORE JSON Helper";
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        ResponseAsJson: JsonToken;
        JsonObj: JsonObject;
        InvalidResponseErr: Label 'Invalid JSON response content.';
        UnexpectedErr: Label 'Unexpected error while connecting to the API.';
        CallFailedErr: Label 'Calling API failed.';
        ResponseAsText: Text;
        RequestAsText: Text;
        IAPIProvider: Interface "CORE API Provider";
    begin
        IAPIProvider := APIProvider;

        RequestMessage.Method := Method;
        RequestMessage.SetRequestUri(CreateURL(IAPIProvider, Path));

        IAPIProvider.SetRequestHeaders(Client);
        IAPIProvider.SetAuthentication(Client);

        if HasRequestContent then begin
            SetRequestContent(JsonContent, RequestContent);

            RequestContent.GetHeaders(ContentHeaders);
            if ContentHeaders.Contains('Content-Type') then
                ContentHeaders.Remove('Content-Type');
            IAPIProvider.SetContentHeaders(ContentHeaders);

            RequestMessage.Content := RequestContent;
        end;

        if not Client.Send(RequestMessage, ResponseMessage) then begin
            ErrorEntryNo := TechnicalLoggingHelper.LogError(Format(APIProvider), Path, UnexpectedErr, ResponseMessage.HttpStatusCode(), "CORE Logging Level"::Critical);
            if GuiAllowed() then
                Error(UnexpectedErr);
        end;

        HttpStatusCode := ResponseMessage.HttpStatusCode();

        if not ResponseMessage.IsSuccessStatusCode() then begin
            if ResponseMessage.Content.ReadAs(ResponseAsText) then begin
                JsonContent.WriteTo(RequestAsText);
                ErrorEntryNo := TechnicalLoggingHelper.LogError(Format(APIProvider), Path, CallFailedErr, ResponseMessage.HttpStatusCode(), RequestAsText, ResponseAsText, "CORE Logging Level"::Error);
                if ResponseAsJson.ReadFrom(ResponseAsText) then
                    exit(ResponseAsJson);
                JSONHelper.AddValue(JsonObj, 'response_as_text', ResponseAsText);
                exit(JsonObj.AsToken());
            end;
            ErrorEntryNo := TechnicalLoggingHelper.LogError(Format(APIProvider), Path, CallFailedErr, ResponseMessage.HttpStatusCode(), "CORE Logging Level"::Error);
            exit;
        end;

        if not ResponseMessage.Content.ReadAs(ResponseAsText) then
            Error(InvalidResponseErr);

        ResponseAsJson.ReadFrom(ResponseAsText);
        exit(ResponseAsJson);
    end;

    local procedure CreateURL(IAPIProvider: Interface "CORE API Provider"; Path: Text): Text
    begin
        if Path.StartsWith('http://') or Path.StartsWith('https://') then
            exit(Path);

        if not Path.StartsWith('/') then
            Path := '/' + Path;

        exit(IAPIProvider.GetBaseURL() + Path);
    end;

    local procedure SetRequestContent(Content: JsonToken; var RequestContent: HttpContent)
    var
        SerializedRequest: Text;
    begin
        Content.WriteTo(SerializedRequest);
        RequestContent.WriteFrom(SerializedRequest);
    end;

    procedure IsSuccessStatusCode(HttpStatusCode: Integer): Boolean
    begin
        if Format(HttpStatusCode).StartsWith('2') and (StrLen(Format(HttpStatusCode)) = 3) then
            exit(true);
    end;

    var
        TechnicalLoggingHelper: Codeunit "CORE Technical Logging Helper";
}
