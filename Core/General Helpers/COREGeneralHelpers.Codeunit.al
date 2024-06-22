namespace Own.Core.Helpers;

using System.Utilities;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.Calendar;

codeunit 50012 "CORE General Helpers"
{
    procedure SplitAddress(Address: Text; var Street: Text[100]; var Number: Integer; var Extension: Text[8]): Boolean
    var
        Matches: Record Matches;
        Groups: Record Groups;
        Regex_Options: Record "Regex Options";
        Regex: Codeunit Regex;
        GroupNumbers: List of [Integer];
        Failed: Boolean;
        Street2: Text[100];
        Number2: Integer;
        Extension2: Text[8];
    begin
        Clear(Failed);
        Regex_Options.IgnoreCase := true;
        Regex.Match(Address, '(.+)\s(\d+[0-9]*)(.*)', Regex_Options, Matches);  //Straatnaam 1, Straatnaam 1 A, Straatnaam 1 A2
        Regex.GetGroupNumbers(GroupNumbers);
        if Matches.Get(0) then
            if Matches.Success then begin
                Regex.Groups(Matches, Groups);
                if Groups.Get(1) then
                    Street := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Street));
                if Groups.Get(2) then
                    if not Evaluate(Number, Groups.ReadValue()) then
                        Failed := true;
                if Groups.Get(3) then
                    Extension := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Extension));
                if not Failed then begin
                    if SplitAddress(Street, Street2, Number2, Extension2) then begin //Straatnaam 71 2H
                        Street := Street2;
                        Extension := Format(Number) + Extension;
                        Number := Number2;
                    end;
                    exit(true);
                end;
            end;

        Clear(Failed);
        Regex_Options.IgnoreCase := true;
        Regex.Match(Address, '(^.*?)([ ][\d]+[ ]*)(.*)|', Regex_Options, Matches); //1-7-4 Dual Ampstreet 130 A, 1-7-4 Dual Ampstreet 130A
        Regex.GetGroupNumbers(GroupNumbers);
        if Matches.Get(0) then
            if Matches.Success then begin
                Regex.Groups(Matches, Groups);
                if Groups.Get(1) then
                    Street := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Street));
                if Groups.Get(2) then
                    if not Evaluate(Number, Groups.ReadValue()) then
                        Failed := true;
                if Groups.Get(3) then
                    Extension := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Extension));
                if not Failed then
                    exit(true);
            end;

        Clear(Failed);
        Regex_Options.IgnoreCase := true;
        Regex.Match(Address, '(^.*?)(\d*?$)', Regex_Options, Matches); //245e oosterkade 9
        Regex.GetGroupNumbers(GroupNumbers);
        if Matches.Get(0) then
            if Matches.Success then begin
                Regex.Groups(Matches, Groups);
                if Groups.Get(1) then
                    Street := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Street));
                if Groups.Get(2) then
                    if not Evaluate(Number, Groups.ReadValue()) then
                        Failed := true;
                if not Failed then
                    exit(true);
            end;

        Clear(Failed);
        Regex_Options.IgnoreCase := true;
        Regex.Match(Address, '(^[\d]+[ ])(.+$)|', Regex_Options, Matches); //12 Straatnaam 
        Regex.GetGroupNumbers(GroupNumbers);
        if Matches.Get(0) then
            if Matches.Success then begin
                Regex.Groups(Matches, Groups);
                if Groups.Get(2) then
                    Street := CopyStr(Groups.ReadValue(), 1, MaxStrLen(Street));
                if Groups.Get(1) then
                    if not Evaluate(Number, Groups.ReadValue()) then
                        Failed := true;
                if not Failed then
                    exit(true);
            end;

        exit(false);
    end;

    procedure GetOptionIndex(Val: Text; FldRef: FieldRef): Integer
    var
        OptionMembers: List of [Text];
        OptionDoesNotExistErr: Label 'Value %1 does not exist for %2.', Comment = '%1 = Value, %2 = Option FieldCaption';
    begin
        Val := Val.ToLower();

        OptionMembers := LowerCase(FldRef.OptionMembers()).Split(',');
        if OptionMembers.Contains(Val) then
            exit(FldRef.GetEnumValueOrdinal(OptionMembers.IndexOf(Val)));

        OptionMembers := LowerCase(FldRef.OptionCaption()).Split(',');
        if OptionMembers.Contains(Val) then
            exit(FldRef.GetEnumValueOrdinal(OptionMembers.IndexOf(Val)));

        Error(OptionDoesNotExistErr, Val, FldRef.Caption());
    end;

    procedure GetNewDateBasedOnWorkingDaysFromCompanyInfo(CurrDate: Date; CurrDateFormula: DateFormula): Date
    var
        CompanyInfo: Record "Company Information";
        CustomizedCalendarChange: array[2] of Record "Customized Calendar Change";
        CalendarManagement: Codeunit "Calendar Management";
    begin
        CompanyInfo.Get();
        CustomizedCalendarChange[1].SetSource(Enum::"Calendar Source Type"::Company, '', '', CompanyInfo."Base Calendar Code");
        exit(CalendarManagement.CalcDateBOC(Format(CurrDateFormula), CurrDate, CustomizedCalendarChange, false));
    end;

    procedure GetAge(FromDate: Date; ToDate: Date): Integer
    var
        Years: Integer;
        Months: Integer;
    begin
        if FromDate = 0D then
            exit(0);

        if ToDate = 0D then
            ToDate := WorkDate();

        Years := Date2DMY(ToDate, 3) - Date2DMY(FromDate, 3);
        Months := Date2DMY(ToDate, 2) - Date2DMY(FromDate, 2);
        if Months < 0 then begin
            Years -= 1;
            Months := 12 - Months;
        end;
        if ((Date2DMY(ToDate, 1) - Date2DMY(FromDate, 1)) < 0) and (Months = 0) then
            Years -= 1;

        if Years < 0 then
            exit(0);

        exit(Years);
    end;
}
