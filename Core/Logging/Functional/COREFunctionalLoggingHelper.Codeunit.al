namespace Own.Core.Logging;

using Own.Core.Helpers;
using Own.Core.Setup;

codeunit 50009 "CORE Functional Logging Helper"
{
    Permissions =
        tabledata "CORE Functional Log Entry" = RIM,
        tabledata "CORE Functional Log Line" = RIM,
        tabledata "CORE Setup" = R;

    procedure PostLoggingEntry(ProcessId: Guid; ObjType: Enum "CORE Object Type"; ObjNo: Integer; LogType: Enum "CORE Logging Level"; Message: Text)
    var
        Setup: Record "CORE Setup";
        Response: JsonToken;
        RequestBody: JsonObject;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
    begin
        if not Setup.Get() or not Setup."Functional Logging Active" then
            exit;

        JSONHelper.AddValue(RequestBody, 'ProcessId', FormattedGuid(ProcessId));
        JSONHelper.AddValue(RequestBody, 'ObjectType', ObjType.AsInteger());
        JSONHelper.AddValue(RequestBody, 'ObjectNo', ObjNo);
        JSONHelper.AddValue(RequestBody, 'LogType', LogType.AsInteger());
        JSONHelper.AddValue(RequestBody, 'Message', Message);

        Response := APIHelper.Post(APIProvider::"BC Connect", '/api/FunctionalLogging', RequestBody, StatusCode);
    end;

    procedure GetLoggingEntries(ProcessDescription: Text; Department: Enum "CORE Department"; ProcessId: Guid)
    var
        Setup: Record "CORE Setup";
        Response: JsonToken;
        APIProvider: Enum "CORE API Provider";
        StatusCode: Integer;
    begin
        if not Setup.Get() or not Setup."Functional Logging Active" then
            exit;

        Response := APIHelper.Get(APIProvider::"BC Connect", '/api/FunctionalLogging', StatusCode);

        if StatusCode = 200 then
            ProcessResponse(ProcessDescription, Department, ProcessId, Response);
    end;

    local procedure ProcessResponse(ProcessDescription: Text; Department: Enum "CORE Department"; ProcessId: Guid; LogEntries: JsonToken)
    var
        FunctionalLogEntry: Record "CORE Functional Log Entry";
        FunctionalLogLine: Record "CORE Functional Log Line";
        LogEntry: JsonToken;
        i: Integer;
    begin
        FunctionalLogEntry.Init();
        FunctionalLogEntry.Department := Department;
        FunctionalLogEntry.Description := CopyStr(ProcessDescription, 1, MaxStrLen(FunctionalLogEntry.Description));
        FunctionalLogEntry."User Id" := CopyStr(UserId(), 1, MaxStrLen(FunctionalLogEntry."User Id"));
        FunctionalLogEntry.Created := CurrentDateTime();
        FunctionalLogEntry.Insert(true);

        i := 10000;

        if LogEntries.IsArray() then
            foreach LogEntry in LogEntries.AsArray() do begin
                FunctionalLogLine.Init();
                FunctionalLogLine."Process Id" := ProcessId;
                FunctionalLogLine."Line No." := i;
                case JSONHelper.GetIntegerValue(LogEntry, 'logType') of
                    0:
                        FunctionalLogLine."Log Type" := FunctionalLogLine."Log Type"::Informational;
                    1:
                        FunctionalLogLine."Log Type" := FunctionalLogLine."Log Type"::Warning;
                    2:
                        FunctionalLogLine."Log Type" := FunctionalLogLine."Log Type"::Error;
                    3:
                        FunctionalLogLine."Log Type" := FunctionalLogLine."Log Type"::Critical;
                end;
                case JSONHelper.GetIntegerValue(LogEntry, 'objectType') of
                    0:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::Codeunit;
                    1:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::Report;
                    2:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::Query;
                    3:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::Page;
                    4:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::Table;
                    5:
                        FunctionalLogLine."Object Type" := FunctionalLogLine."Object Type"::XMLPort;
                end;
                FunctionalLogLine."Object No." := JSONHelper.GetIntegerValue(LogEntry, 'objectNo');
                FunctionalLogLine.Message := CopyStr(JSONHelper.GetTextValue(LogEntry, 'message'), 1, MaxStrLen(FunctionalLogLine.Message));
                FunctionalLogLine.Created := JSONHelper.GetDateTimeValue(LogEntry, 'created');
                i += 10000;
                FunctionalLogLine.Insert(true);
            end;

        FunctionalLogEntry."Last Message" := FunctionalLogLine.Message;
        FunctionalLogEntry.Modify(true);
    end;

    local procedure FormattedGuid(TheGuid: Guid): Text
    begin
        exit(DelChr(Format(TheGuid), '=', '{}'));
    end;

    procedure CreateLogEntry(Department: Enum "CORE Department"; Description: Text[100]): Guid
    var
        Setup: Record "CORE Setup";
        FunctionalLogEntry: Record "CORE Functional Log Entry";
        IsHandled: Boolean;
    begin
        OnBeforeCreateLogEntryOrLine(IsHandled);
        if IsHandled then
            exit;

        if not Setup.Get() or not Setup."Functional Logging Active" then
            exit;

        FunctionalLogEntry.Init();
        FunctionalLogEntry.Id := CreateGuid();
        FunctionalLogEntry.Created := CurrentDateTime();
        FunctionalLogEntry."User Id" := CopyStr(UserId, 1, MaxStrLen(FunctionalLogEntry."User Id"));
        FunctionalLogEntry.Department := Department;
        FunctionalLogEntry.Description := CopyStr(Description, 1, MaxStrLen(FunctionalLogEntry.Description));
        FunctionalLogEntry.Insert(true);

        exit(FunctionalLogEntry.Id);
    end;

    procedure CreateLogEntryLine(Id: Guid; LoggingLevel: Enum "CORE Logging Level"; Object: Enum "CORE Object Type"; ObjectNo: Integer; Message: Text)
    var
        String: Text;
    begin
        if StrLen(Message) > 250 then begin
            String := CopyStr(Message, 1, 250);
            CreateLogEntryLine(Id, LoggingLevel, Object, ObjectNo, String, '');
            CreateLogEntryLine(Id, LoggingLevel, Object, ObjectNo, CopyStr(Message, 251));
        end else
            CreateLogEntryLine(Id, LoggingLevel, Object, ObjectNo, Message, '');
    end;

    procedure CreateLogEntryLine(Id: Guid; LoggingLevel: Enum "CORE Logging Level"; Object: Enum "CORE Object Type"; ObjectNo: Integer; Message: Text; CallStack: Text)
    var
        Setup: Record "CORE Setup";
        FunctionalLogEntry: Record "CORE Functional Log Entry";
        FunctionalLogLine: Record "CORE Functional Log Line";
        IsHandled: Boolean;
        OutStr: OutStream;
    begin
        OnBeforeCreateLogEntryOrLine(IsHandled);
        if IsHandled then
            exit;

        if not Setup.Get() or not Setup."Functional Logging Active" then
            exit;

        if not FunctionalLogEntry.Get(Id) then
            exit;

        FunctionalLogLine.Init();
        FunctionalLogLine."Process Id" := Id;
        FunctionalLogLine."Line No." := GetNextLineNo(Id);
        FunctionalLogLine.Created := CurrentDateTime();
        FunctionalLogLine."Log Type" := LoggingLevel;
        FunctionalLogLine."Object Type" := Object;
        FunctionalLogLine."Object No." := ObjectNo;
        FunctionalLogLine.Message := CopyStr(Message, 1, MaxStrLen(FunctionalLogLine.Message));
        FunctionalLogLine."User Id" := CopyStr(UserId, 1, MaxStrLen(FunctionalLogLine."User Id"));
        FunctionalLogLine.Insert(true);

        if CallStack <> '' then begin
            FunctionalLogLine."Call Stack".CreateOutStream(OutStr);
            OutStr.WriteText(CallStack);
            FunctionalLogLine.Modify(true);
        end;

        FunctionalLogEntry."Last Message" := CopyStr(Message, 1, MaxStrLen(FunctionalLogEntry."Last Message"));
        FunctionalLogEntry.Modify(true);
    end;

    local procedure GetNextLineNo(Id: Guid): Integer
    var
        FunctionalLogLine: Record "CORE Functional Log Line";
    begin
        FunctionalLogLine.SetRange("Process Id", Id);
        if FunctionalLogLine.FindLast() then
            exit(FunctionalLogLine."Line No." + 10000);
        exit(10000);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateLogEntryOrLine(var IsHandled: Boolean)
    begin
    end;

    var
        APIHelper: Codeunit "CORE API Helper";
        JSONHelper: Codeunit "CORE JSON Helper";
}
