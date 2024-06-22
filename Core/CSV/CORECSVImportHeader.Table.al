namespace Own.Core.CSV;

using System.IO;

table 50006 "CORE CSV Import Header"
{
    Caption = 'CSV Import Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Type; Enum "CORE CSV Import Type")
        {
            Caption = 'Type';
        }
        field(3; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "New","To Process","Partly Processed","Processed","Ignored","Error";
            OptionCaption = 'New,To Process,Partly Processed,Processed,Ignored,Error';
        }
        field(4; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            FieldClass = FlowField;
            CalcFormula = count("CORE CSV Import Error" where("Entry No." = field("Entry No.")));
            Editable = false;
        }
        field(5; "Processing Error"; Boolean)
        {
            Caption = 'Processing Error';
            FieldClass = FlowField;
            CalcFormula = exist("CORE CSV Import Line" where("Entry No." = field("Entry No."), "Processing Error" = filter(true)));
            Editable = false;
        }
        field(6; FileName; Text[250])
        {
            Caption = 'FileName';
        }
        field(7; Data; Blob)
        {
            Caption = 'Data';
        }
        field(8; "Imported At"; DateTime)
        {
            Caption = 'Imported At';
        }
        field(9; "Imported By"; Code[50])
        {
            Caption = 'Imported By';
        }
        field(10; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
        }
        field(11; "Processed By"; Code[50])
        {
            Caption = 'Processed By';
        }
        field(12; "Checked At"; DateTime)
        {
            Caption = 'Checked At';
        }
        field(13; "Checked By"; Code[50])
        {
            Caption = 'Checked By';
        }
        field(14; Delimiter; Text[1])
        {
            Caption = 'Delimiter';
            AllowInCustomizations = Never;
        }
        field(15; "File has Header"; Boolean)
        {
            Caption = 'File has Header';
            AllowInCustomizations = Never;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }


    procedure ReadCSV(CSVStream: InStream; SelectedFileName: Text; ImportType: Enum "CORE CSV Import Type"; FieldDelimiter: Text[1]; HasHeader: Boolean)
    var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        CSVImportLine: Record "CORE CSV Import Line";
        InStr: InStream;
        RowCount: Integer;
        ColumnCount: Integer;
        Row: Integer;
        Col: Integer;
    begin
        Rec.Init();
        Rec."Entry No." := 0;
        Rec.FileName := CopyStr(SelectedFileName, 1, MaxStrLen(Rec.FileName));
        Rec."Imported At" := CurrentDateTime();
        Rec."Imported By" := CopyStr(UserId, 1, MaxStrLen(Rec."Imported By"));
        Rec.Status := Rec.Status::New;
        Rec.Type := ImportType;
        Rec.Data.CreateInStream(InStr);
        InStr := CSVStream;
        Rec.Insert(true);

        TempCSVBuffer.Reset();
        TempCSVBuffer.DeleteAll(true);
        TempCSVBuffer.LoadDataFromStream(InStr, FieldDelimiter);
        RowCount := TempCSVBuffer.GetNumberOfLines();
        ColumnCount := TempCSVBuffer.GetNumberOfColumns();
        for Row := 2 to RowCount do
            for Col := 1 to ColumnCount do begin
                CSVImportLine.Init();
                CSVImportLine."Entry No." := Rec."Entry No.";
                CSVImportLine."Line No." := Row;
                CSVImportLine."Field No." := Col;
                CSVImportLine."Field Value" := TempCSVBuffer.GetValue(Row, Col);
                CSVImportLine."Field Name" := TempCSVBuffer.GetValue(1, Col);
                CSVImportLine.Type := ImportType;
                CSVImportLine.Status := CSVImportLine.Status::New;
                CSVImportLine.Insert(true);
            end;
    end;

    procedure SetStatus()
    var
        CSVImportLine: Record "CORE CSV Import Line";
    begin
        CSVImportLine.SetRange("Entry No.", Rec."Entry No.");
        CSVImportLine.SetRange(Status, CSVImportLine.Status::Error);
        if not CSVImportLine.IsEmpty() then begin
            Rec.Validate(Status, Rec.Status::Error);
            exit;
        end;
        CSVImportLine.SetRange(Status, CSVImportLine.Status::"To Process");
        if not CSVImportLine.IsEmpty() then begin
            Rec.Validate(Status, Rec.Status::"To Process");
            exit;
        end;
        CSVImportLine.SetRange(Status, CSVImportLine.Status::Ignored);
        if not CSVImportLine.IsEmpty() then begin
            Rec.Validate(Status, Rec.Status::Ignored);
            exit;
        end;
        CSVImportLine.SetRange(Status, CSVImportLine.Status::Processed);
        if not CSVImportLine.IsEmpty() then begin
            CSVImportLine.SetFilter(Status, '<>%1', Status::Processed);
            if not CSVImportLine.IsEmpty then begin
                Rec.Validate(Status, Rec.Status::"Partly Processed");
                Rec.Validate("Processed At", CurrentDateTime());
                Rec.Validate("Processed By", CopyStr(UserId, 1, MaxStrLen(Rec."Processed By")));
                exit;
            end;
            Rec.Validate(Status, Rec.Status::"Processed");
            exit;
        end;
        Rec.Validate(Status, Rec.Status::New);
    end;
}
