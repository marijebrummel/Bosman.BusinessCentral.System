namespace Own.Core.CSV;

page 50009 "CORE CSV Import"
{
    ApplicationArea = All;
    Caption = 'CSV Import';
    PageType = Card;
    SourceTable = "CORE CSV Import Header";
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(FileName; Rec.FileName)
                {
                    ToolTip = 'Specifies the value of the FileName field.';
                }
                field("Imported At"; Rec."Imported At")
                {
                    ToolTip = 'Specifies the value of the Imported At field.';
                }
                field("Imported By"; Rec."Imported By")
                {
                    ToolTip = 'Specifies the value of the Imported By field.';
                }
                field("Checked At"; Rec."Checked At")
                {
                    ToolTip = 'Specifies the value of the Checked At field.';
                }
                field("Checked By"; Rec."Checked By")
                {
                    ToolTip = 'Specifies the value of the Checked By field.';
                }
                field("Processed At"; Rec."Processed At")
                {
                    ToolTip = 'Specifies the value of the Processed At field.';
                }
                field("Processed By"; Rec."Processed By")
                {
                    ToolTip = 'Specifies the value of the Processed By field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Processing Error"; Rec."Processing Error")
                {
                    ToolTip = 'Specifies the value of the Processing Error field.';
                }
                field("Error Count"; Rec."Error Count")
                {
                    ToolTip = 'Specifies the value of the Error Count field.';
                }
            }
            part(Lines; "CORE CSV Import Matrix")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
            actionref(Check_Promoted; Check) { }
            actionref(Process_Promoted; Process) { }
        }
    }

}
