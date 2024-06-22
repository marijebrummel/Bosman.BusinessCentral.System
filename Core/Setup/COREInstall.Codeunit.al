namespace Own.Core.System;

using System.Threading;
using Own.Core.Logging;

codeunit 50011 "CORE Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateJobQueueEntryClearLog();
    end;


    local procedure CreateJobQueueEntryClearLog()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueMgt: Codeunit "Job Queue Management";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"CORE Clear Log Entries");
        if JobQueueEntry.IsEmpty() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Object ID to Run" := Codeunit::"CORE Clear Log Entries";
            JobQueueEntry."No. of Minutes between Runs" := 1440;
            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;
            JobQueueMgt.CreateJobQueueEntry(JobQueueEntry);

            JobQueueEntry.Description := CopyStr('Clean up error log', 1, MaxStrLen(JobQueueEntry.Description));
            JobQueueEntry.Modify();

            JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
        end;
    end;
}
