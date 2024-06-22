namespace Own.Core.Setup;

using Own.Core.Security;

page 50004 "CORE Setup"
{
    Caption = 'Asker General Setup';
    AdditionalSearchTerms = 'CORE, CORE Setup', Locked = true;
    PageType = Card;
    SourceTable = "CORE Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(BCConnectAPI)
            {
                Caption = 'Business Central Connect API', Locked = true;

                grid(A)
                {
                    ShowCaption = false;
                    group(API)
                    {
                        ShowCaption = false;

                        field("BC Connect Api Key KV Name"; Rec."BC Connect Api Key KV Name")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the name of the key vault secret name for the BC connect api key.';
                            ShowMandatory = true;
                        }
                        field("BC Connect API Base URL"; Rec."BC Connect API Base URL")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the BC Connect API Base URL field.';
                            ShowMandatory = true;
                        }
                    }
                }
            }
            group(Logging)
            {
                Caption = 'Logging', Locked = true;

                group(technical)
                {
                    Caption = 'Technical';

                    field("Technical Logging Active"; Rec."Technical Logging Active")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Technical Logging Active field.';
                    }
                }
                group(functional)
                {
                    Caption = 'Functional';

                    field("Functional Logging Active"; Rec."Functional Logging Active")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Functional Logging Active field.';
                    }
                    group(functional_sub)
                    {
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Test Key Vault")
            {
                Caption = 'Check KeyVault Connection';
                ApplicationArea = All;
                Image = TestFile;

                trigger OnAction()
                var
                    KeyvaultHelper: Codeunit "CORE Key Vault Helper";
                begin
                    Message(KeyvaultHelper.GetSecretFromKeyVault('keyvault-test'));
                end;
            }

            action("Ping API")
            {
                Caption = 'Ping BC Connect API';
                ApplicationArea = All;
                Image = TestFile;

                trigger OnAction()
                begin
                    Rec.Ping();
                end;
            }
        }
        area(Promoted)
        {
            actionref(TestKeyVault_Promoted; "Test Key Vault") { }
            actionref(PingAPI_Promoted; "Ping API") { }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Technical Logging Active" := true;
            Rec."Functional Logging Active" := false;
            Rec.Insert(true);
        end;
    end;

}
