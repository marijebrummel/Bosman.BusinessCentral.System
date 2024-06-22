namespace Own.Core.FTP;

page 50008 "CORE FTP Settings"
{
    ApplicationArea = All;
    Caption = 'FTP Settings';
    PageType = List;
    SourceTable = "CORE FTP Settings";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Host; Rec.Host)
                {
                    ToolTip = 'Specifies the value of the Host field.';
                }
                field("User Name KV Name"; Rec."User Name KV Name")
                {
                    ToolTip = 'Specifies the value of the User Name KV Name field.';
                }
                field("Password KV Name"; Rec."Password KV Name")
                {
                    ToolTip = 'Specifies the value of the Password KV Name field.';
                }
                field("Remote Path Upload"; Rec."Remote Path Upload")
                {
                    ToolTip = 'Specifies the value of the Remote Path Upload field.';
                }
                field("Overwrite Existing"; Rec."Overwrite Existing")
                {
                    ToolTip = 'Specifies the value of the Overwrite Existing field.';
                }
                field("Remote Path Download"; Rec."Remote Path Download")
                {
                    ToolTip = 'Specifies the value of the Remote Path Download field.';
                }
                field("Move After Download"; Rec."Move After Download")
                {
                    ToolTip = 'Specifies the value of the Move After Download field.';
                }
                field("Delete After Download"; Rec."Delete After Download")
                {
                    ToolTip = 'Specifies the value of the Delete After Download field.';
                }
                field("Remote Path Move To"; Rec."Remote Path Move To")
                {
                    ToolTip = 'Specifies the value of the Remote Path Move To field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TestUpload)
            {
                Caption = 'Test Upload';
                ApplicationArea = All;
                Image = TestFile;
                ToolTip = 'Tests the connection with the (S)FTP(S) by uploading a file.';

                trigger OnAction()
                begin
                    Rec.TestUpload();
                end;
            }
            action(TestDownload)
            {
                Caption = 'Test Download';
                ApplicationArea = All;
                Image = TestFile;
                ToolTip = 'Tests the connection with the (S)FTP(S) by uploading and then downloading a file.';

                trigger OnAction()
                begin
                    Rec.TestDownload();
                end;
            }
        }
        area(Promoted)
        {
            actionref(TestUpload_Promoted; TestUpload) { }
            actionref(TestDownload_Promoted; TestDownload) { }
        }
    }
}
