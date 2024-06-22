namespace Own.Core.Logging;

page 50007 "CORE Functional Log Lines"
{
    Caption = 'Functional Log Lines';
    PageType = ListPart;
    SourceTable = "CORE Functional Log Line";
    Editable = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field("Log Type"; Rec."Log Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Log Type field.';
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Type field.';
                }
                field("Object No."; Rec."Object No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object No. field.';
                }
                field("Message"; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CallStackTxt; CallStackTxt)
                {
                    Caption = 'Call Stack';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Call Stack field.';

                    trigger OnDrillDown()
                    begin
                        if Rec."Call Stack".HasValue() then
                            DownloadCallStack();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(CallStackTxt);
        if Rec."Call Stack".HasValue() then
            CallStackTxt := 'Download Callstack';
    end;

    local procedure DownloadCallStack()
    var
        InStr: InStream;
        FileNameLbl: Label 'Callstack - %1.txt', Comment = '%1 = Current DateTime';
        FileNameTxt: Text;
    begin
        Rec.Calcfields("Call Stack");
        Rec."Call Stack".CreateInStream(InStr);
        FileNameTxt := StrSubstNo(FileNameLbl, Format(CurrentDateTime));
        DownloadFromStream(InStr, '', '', '', FileNameTxt);
    end;

    var
        CallStackTxt: Text;
}
