namespace Own.Core.Logging;

codeunit 50010 "CORE Clear Log Entries" //TODO retention policy ipv JQ
{
    Permissions = tabledata "CORE Functional Log Entry" = rd,
                    tabledata "CORE Functional Log Line" = rd,
                    tabledata "CORE Technical Log Entry" = rd;

    trigger OnRun()
    begin
        CleanTechnicalErrorLog();
        CleanFunctionalLog();
    end;

    local procedure CleanTechnicalErrorLog()
    var
        LogEntry: Record "CORE Technical Log Entry";
    begin
        LogEntry.SetFilter(Created, '<%1', CreateDateTime(CalcDate('<-2W>', Today()), 0T));
        if LogEntry.FindSet() then
            LogEntry.DeleteAll(true);
    end;

    local procedure CleanFunctionalLog()
    var
        LogEntry: Record "CORE Functional Log Entry";
    begin
        LogEntry.SetFilter(Created, '<%1', CreateDateTime(CalcDate('<-2W>', Today()), 0T));
        if LogEntry.FindSet() then
            LogEntry.DeleteAll(true);
    end;
}
