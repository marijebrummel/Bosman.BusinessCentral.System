namespace Own.Core.FixedLength;

page 50016 "CORE Fixed Length Import Lines"
{
    ApplicationArea = All;
    Caption = 'Fixed Length Import Lines';
    PageType = List;
    SourceTable = "CORE Fixed Length Import Line";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;

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
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
                }
                field(Data; Rec.Data)
                {
                    ToolTip = 'Specifies the value of the Data field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
            }
        }
    }
}
