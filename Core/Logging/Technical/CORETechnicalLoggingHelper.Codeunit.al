codeunit 50005 "CORE Technical Logging Helper"
{
    Permissions = tabledata "CORE Technical Log Entry" = rim;

    procedure LogError(Service: Text; Path: Text; ErrorMsg: Text; StatusCode: Integer; Level: Enum "CORE Logging Level"): Integer
    var
        Setup: Record "CORE Setup";
    begin
        if not Setup.Get() or not Setup."Technical Logging Active" then
            exit;

        exit(LogError(Service, Path, ErrorMsg, StatusCode, '', Level));
    end;

    procedure LogError(Service: Text; Path: Text; ErrorMsg: Text; StatusCode: Integer; Response: Text; Level: Enum "CORE Logging Level"): Integer
    begin
        exit(LogError(Service, Path, ErrorMsg, StatusCode, '', Response, Level));
    end;

    procedure LogError(Service: Text; Path: Text; ErrorMsg: Text; StatusCode: Integer; Request: Text; Response: Text; Level: Enum "CORE Logging Level"): Integer
    var
        Setup: Record "CORE Setup";
        LogEntry: Record "CORE Technical Log Entry";
        OutStr: OutStream;
    begin
        if not Setup.Get() or not Setup."Technical Logging Active" then
            exit;

        LogEntry.Init();

        LogEntry.Service := CopyStr(Service, 1, MaxStrLen(LogEntry.Service));
        LogEntry.Message := CopyStr(ErrorMsg + ' - ' + Path, 1, MaxStrLen(LogEntry.Message));
        LogEntry."Status Code" := StatusCode;
        LogEntry."Status Code Description" := CopyStr(GetStatusCodeDescription(StatusCode), 1, MaxStrLen(LogEntry."Status Code Description"));
        LogEntry.Path := CopyStr(Path, 1, MaxStrLen(LogEntry.Path));

        OnBeforeSetErrorMessage(ErrorMsg);
        LogEntry.Message := CopyStr(ErrorMsg, 1, MaxStrLen(LogEntry.Message));
        LogEntry.Level := Level;

        LogEntry.Body.CreateOutStream(OutStr);
        OutStr.Write(Response);
        Clear(OutStr);
        LogEntry.Request.CreateOutStream(OutStr);
        OutStr.Write(Request);

        LogEntry.Insert(true);

        exit(LogEntry."Entry No.");
    end;

    local procedure GetStatusCodeDescription(StatusCode: Integer): Text
    var
        The301Err: Label 'Moved Permanently', Locked = true;
        The302Err: Label 'Found', Locked = true;
        The303Err: Label 'See Other', Locked = true;
        The304Err: Label 'Not Modified', Locked = true;
        The307Err: Label 'Temporary Redirect', Locked = true;
        The400Err: Label 'Bad Request', Locked = true;
        The401Err: Label 'Unauthorized', Locked = true;
        The403Err: Label 'Forbidden', Locked = true;
        The404Err: Label 'Not Found', Locked = true;
        The405Err: Label 'Method not Allowed', Locked = true;
        The406Err: Label 'Not Acceptable', Locked = true;
        The412Err: Label 'Precondition Failed', Locked = true;
        The415Err: Label 'Unsupported Media Type', Locked = true;
        The500Err: Label 'Internal Server Error', Locked = true;
        The501Err: Label 'Not Implmented', Locked = true;
    begin
        case StatusCode of
            301:
                exit(The301Err);
            302:
                exit(The302Err);
            303:
                exit(The303Err);
            304:
                exit(The304Err);
            307:
                exit(The307Err);
            400:
                exit(The400Err);
            401:
                exit(The401Err);
            403:
                exit(The403Err);
            404:
                exit(The404Err);
            405:
                exit(The405Err);
            406:
                exit(The406Err);
            412:
                exit(The412Err);
            415:
                exit(The415Err);
            500:
                exit(The500Err);
            501:
                exit(The501Err);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetErrorMessage(var ErrorMsg: Text)
    begin
    end;
}
