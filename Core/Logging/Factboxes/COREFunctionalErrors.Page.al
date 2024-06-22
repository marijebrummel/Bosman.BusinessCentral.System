namespace Own.Core.Logging;

page 50015 "CORE Functional Errors"
{
    ApplicationArea = All;
    Caption = 'Functional Errors';
    PageType = ListPart;
    SourceTable = "CORE Functional Log Line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Message"; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.';
                }
            }
        }
    }
}
