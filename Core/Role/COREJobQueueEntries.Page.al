namespace Own.Core.UI;

using System.Threading;

page 50003 "CORE Job Queue Entries"
{
    Caption = 'Job Queue Entries Overview';
    PageType = ListPart;
    SourceTable = "Job Queue Entry";
    CardPageId = "Job Queue Entry Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the job queue entry. When you create a job queue entry, its status is set to On Hold. You can set the status to Ready and back to On Hold. Otherwise, status information in this field is updated automatically.';
                }
                field("Object Type to Run"; Rec."Object Type to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the object, report or codeunit, that is to be run for the job queue entry. After you specify a type, you then select an object ID of that type in the Object ID to Run field.';
                }
                field("Object ID to Run"; Rec."Object ID to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the object that is to be run for this job. You can select an ID that is of the object type that you have specified in the Object Type to Run field.';
                }
                field("Object Caption to Run"; Rec."Object Caption to Run")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the object that is selected in the Object ID to Run field.';
                    StyleExpr = RecStyle;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there.';
                    StyleExpr = RecStyle;
                }
                field("Earliest Start Date/Time"; Rec."Earliest Start Date/Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest date and time when the dimension correction should be run.  The format for the date and time must be month/day/year hour:minute, and then AM or PM. For example, 3/10/2021 12:00 AM.';
                }
                field(Scheduled; Rec.Scheduled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the job queue entry has been scheduled to run automatically, which happens when an entry changes status to Ready. If the field is cleared, the job queue entry is not scheduled to run.';
                }
                field("Recurring Job"; Rec."Recurring Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the job queue entry is recurring. If the Recurring Job check box is selected, then the job queue entry is recurring. If the check box is cleared, the job queue entry is not recurring. After you specify that a job queue entry is a recurring one, you must specify on which days of the week the job queue entry is to run. Optionally, you can also specify a time of day for the job to run and how many minutes should elapse between runs.';
                }
                field("No. of Minutes between Runs"; Rec."No. of Minutes between Runs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum number of minutes that are to elapse between runs of a job queue entry. This field only has meaning if the job queue entry is set to be a recurring job.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecStyle := 'Standard';
        case Rec.Status of
            Rec.Status::Error:
                RecStyle := 'Unfavorable';
            Rec.Status::"On Hold":
                RecStyle := 'StandardAccent';
        end;
    end;

    var
        RecStyle: Text;
}
