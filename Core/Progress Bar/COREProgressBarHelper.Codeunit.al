namespace Own.Core.Helpers;

using System.IO;

codeunit 50001 "CORE Progress Bar Helper"
{
    #region [Download from source to entity]
    //Used when downloading data without knowing the total size or count
    procedure InitDownloadProgressBar(Entity: Text; Source: Text)
    var
        DownloadingLbl: Label 'Downloading %1 from %2.', Comment = '%1=The entity, %2 = The source';
    begin
        if not GuiAllowed() then
            exit;

        ProgressBar.Init(0, 0, StrSubstNo(DownloadingLbl, Entity, Source));
    end;
    #endregion

    #region [Progress of action in %]
    //Used when downloading / importing / processing data with known size or count
    procedure InitProgressBarPercentage(Message: Text; "Count": Integer; Entity: Text)
    var
        ProgressMsg: Label '%1 %2.', Comment = '%1 = The message, %2 = The entity';
    begin
        if not GuiAllowed() then
            exit;

        TotalCount := "Count";
        ProgressBar.Init("Count", 1, StrSubstNo(ProgressMsg, Message, Entity));
    end;

    procedure UpdateProgressBarPercentage(Step: Integer)
    var
        CurrentProgressMsg: Label 'Current progress: %1%', Comment = '%1=The current percentage';
    begin
        if not GuiAllowed() then
            exit;

        ProgressBar.Update(StrSubstNo(CurrentProgressMsg, Round((100 / TotalCount) * Step, 1)));
    end;
    #endregion

    #region [Progress of action]
    procedure InitProgressBar(Message: Text; "Count": Decimal)
    begin
        if not GuiAllowed() then
            exit;

        TotalCount := Round("Count", 1, '>');
        ProgressBar.Init(TotalCount, 1, Message);
    end;

    procedure UpdateProgressBar(Message: Text; CurrentCount: Decimal)
    var
        ProgressMsg: Text;
    begin
        if not GuiAllowed() then
            exit;

        ProgressMsg := Message + ' %1 of %2';

        ProgressBar.Update(StrSubstNo(ProgressMsg, Round(CurrentCount, 1, '>'), TotalCount));
    end;
    #endregion

    procedure Close()
    begin
        if not GuiAllowed() then
            exit;

        Sleep(500);
        ProgressBar.Close();
    end;

    var
        ProgressBar: Codeunit "Config. Progress Bar";
        TotalCount: Integer;
}

