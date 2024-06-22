namespace Own.Core.CSV;

page 50010 "CORE CSV Imported Files"
{
    ApplicationArea = All;
    Caption = 'Imported CSV Files';
    PageType = List;
    SourceTable = "CORE CSV Import Header";
    UsageCategory = Lists;
    CardPageId = "CORE CSV Import";
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    StyleExpr = StatusStyle;
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    StyleExpr = StatusStyle;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    StyleExpr = StatusStyle;
                }
                field("Processing Error"; Rec."Processing Error")
                {
                    ToolTip = 'Specifies the value of the Processing Error field.';
                    StyleExpr = StatusStyle;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ToolTip = 'Specifies the value of the Error Count field.';
                    StyleExpr = StatusStyle;
                }
                field("Imported At"; Rec."Imported At")
                {
                    ToolTip = 'Specifies the value of the Imported At field.';
                    StyleExpr = StatusStyle;
                }
                field("Checked At"; Rec."Checked At")
                {
                    ToolTip = 'Specifies the value of the Checked At field.';
                    StyleExpr = StatusStyle;
                }
                field("Processed At"; Rec."Processed At")
                {
                    ToolTip = 'Specifies the value of the Processed At field.';
                    StyleExpr = StatusStyle;
                }
                field(FileName; Rec.FileName)
                {
                    ToolTip = 'Specifies the value of the FileName field.';
                    StyleExpr = StatusStyle;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                begin
                    SelectCSV();
                end;
            }
            action(Check)
            {
                Caption = 'Check';
                ApplicationArea = All;
                Image = ViewDescription;

                trigger OnAction()
                var
                    ImportHeader: Record "CORE CSV Import Header";
                    CSVMgt: Interface "CORE CSV Mgt.";
                begin
                    CurrPage.SetSelectionFilter(ImportHeader);
                    if ImportHeader.FindSet() then
                        repeat
                            CSVMgt := ImportHeader.Type;
                            CSVMgt.CheckImportHeader(ImportHeader);
                        until ImportHeader.Next() = 0;
                    CurrPage.Update(true);
                end;
            }
            action(Process)
            {
                Caption = 'Process';
                ApplicationArea = All;
                Image = Process;

                trigger OnAction()
                var
                    ImportHeader: Record "CORE CSV Import Header";
                    CSVMgt: Interface "CORE CSV Mgt.";
                begin
                    CurrPage.SetSelectionFilter(ImportHeader);
                    if ImportHeader.FindSet() then
                        repeat
                            CSVMgt := ImportHeader.Type;
                            CSVMgt.ProcessImportHeader(ImportHeader);
                        until ImportHeader.Next() = 0;
                    CurrPage.Update(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ImportCustomers_Promoted; "Import") { }
            actionref(Check_Promoted; Check) { }
            actionref(Process_Promoted; Process) { }
        }
    }

    internal procedure SelectCSV()
    var
        ManualImport: Page "CORE CSV Manual Import";
        InStr: InStream;
        SelectedFileName: Text;
    begin
        if ManualImport.RunModal() = Action::OK then
            if UploadIntoStream('Select File', '', '', SelectedFileName, InStr) then
                Rec.ReadCSV(InStr, SelectedFileName, ManualImport.GetType(), ManualImport.GetDelimiter(), ManualImport.GetHasHeader());
    end;

    trigger OnAfterGetRecord()
    begin
        StatusStyle := 'Standard';
        Rec.CalcFields("Processing Error");
        if Rec."Processing Error" then
            StatusStyle := 'Attention'
        else
            case Rec.Status of
                Rec.Status::Error:
                    StatusStyle := 'Attention';
                Rec.Status::Ignored:
                    StatusStyle := 'StandardAccent';
                Rec.Status::"Partly Processed":
                    StatusStyle := 'Strong';
                Rec.Status::Processed:
                    StatusStyle := 'Favorable';
            end;
    end;

    var
        StatusStyle: Text;
}
