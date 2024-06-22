namespace Own.Core.Logging;

page 50014 "CORE Technical Errors"
{
    ApplicationArea = All;
    Caption = 'Technical Errors';
    PageType = ListPart;
    SourceTable = "CORE Technical Log Entry";
    CardPageId = "CORE Technical Log Entry";

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
