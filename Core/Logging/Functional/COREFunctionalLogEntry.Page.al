namespace Own.Core.Logging;

page 50006 "CORE Functional Log Entry"
{
    Caption = 'Functional Log Entry ';
    PageType = Card;
    SourceTable = "CORE Functional Log Entry";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    DataCaptionExpression = Rec.Description;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User field.';
                }
            }
            part("Functional Log Lines"; "CORE Functional Log Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Process Id" = field(Id);
            }
        }
    }
}
