namespace Own.Core.UI;

using Own.Core.Logging;
using Own.Core.Setup;

page 50002 "CORE BPD Manager"
{
    Caption = 'Business Process Manager', Locked = true;
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part("Job Queue Entries"; "CORE Job Queue Entries")
            {
                ApplicationArea = All;
            }
            part("Technical Log Entries"; "CORE Technical Log Entries")
            {
                ApplicationArea = All;
            }
            part("Functional Log Entries"; "CORE Functional Log Entries")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
        }
        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setup';

                action("Setup BC Core")
                {
                    Caption = 'Asker General Setup';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = page "CORE Setup";
                }
            }
        }
        area(Creation)
        {

        }
    }
}