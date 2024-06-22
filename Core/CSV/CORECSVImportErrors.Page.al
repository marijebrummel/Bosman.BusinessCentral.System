namespace Own.Core.CSV;

page 50013 "CORE CSV Import Errors"
{
    ApplicationArea = All;
    Caption = 'CSV Import Errors';
    PageType = List;
    SourceTable = "CORE CSV Import Error";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Message"; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.';
                }
            }
        }
    }
}
