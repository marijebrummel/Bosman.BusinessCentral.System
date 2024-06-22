namespace Own.Core.Logging;

page 50005 "CORE Functional Log Entries"
{
    ApplicationArea = All;
    Caption = 'Functional Log Entries';
    PageType = ListPart;
    SourceTable = "CORE Functional Log Entry";
    CardPageId = "CORE Functional Log Entry";
    UsageCategory = None;
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting(Created) order(descending);
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Created; Rec.Created)
                {
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    StyleExpr = RecStyle;
                }
                field("User Id"; Rec."User Id")
                {
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Warning; Rec.Warning)
                {
                    ToolTip = 'Specifies if Warning lines exist for the entry.';
                    Visible = false;
                }
                field("Error"; Rec.Error)
                {
                    ToolTip = 'Specifies if (Critical) Error lines exist for the entry.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Delete All")
            {
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    LogLine: Record "CORE Functional Log Line";
                begin
                    if LogLine.FindSet() then
                        LogLine.DeleteAll(true);
                    Rec.DeleteAll(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecStyle := 'Standard';
        Rec.CalcFields(Warning, Error);
        if Rec.Warning then begin
            RecStyle := 'Attention';
            exit;
        end;
        if Rec.Error then begin
            RecStyle := 'Unfavorable';
            exit;
        end;
    end;

    var
        RecStyle: Text;
}