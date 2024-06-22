page 50000 "CORE Technical Log Entries"
{
    ApplicationArea = All;
    Caption = 'Technical Log Entries';
    PageType = ListPart;
    SourceTable = "CORE Technical Log Entry";
    UsageCategory = None;
    CardPageId = "CORE Technical Log Entry";
    SourceTableView = sorting(Created) order(descending);
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Message"; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Message field.';
                    StyleExpr = Style;
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Level field.';
                    Visible = false;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Code field.';
                    BlankZero = true;
                }
                field("Status Code Description"; Rec."Status Code Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Code Description field.';
                    Visible = false;
                }
                field(Service; Rec.Service)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service field.';
                }
            }
        }
    }

    var
        Style: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Level of
            Rec.Level::Informational, Rec.Level::Warning:
                Style := 'Standard';
            Rec.Level::Error:
                Style := 'Attention';
            Rec.Level::Critical:
                Style := 'Unfavorable';
        end;
    end;
}
