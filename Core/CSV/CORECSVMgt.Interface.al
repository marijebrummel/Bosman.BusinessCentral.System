namespace Own.Core.CSV;

interface "CORE CSV Mgt."
{
    procedure SetDelimiter(): Text[1]
    procedure SetHasHeader(): Boolean
    procedure CheckImportHeader(var ImportHeader: Record "CORE CSV Import Header")
    procedure ProcessImportHeader(var ImportHeader: Record "CORE CSV Import Header")
}
