namespace Own.Core.CSV;

table 50008 "CORE CSV Import Error"
{
    Caption = 'CSV Import Error';
    DataClassification = CustomerContent;
    DrillDownPageId = "CORE CSV Import Errors";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Error Line No."; Integer)
        {
            Caption = 'Error Line No.';
        }
        field(100; "Message"; Text[250])
        {
            Caption = 'Message';
        }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.", "Field No.", "Error Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        CSVImportError: Record "CORE CSV Import Error";
    begin
        if Rec."Error Line No." = 0 then begin
            CSVImportError.SetRange("Entry No.", Rec."Entry No.");
            CSVImportError.SetRange("Line No.", Rec."Line No.");
            CSVImportError.SetRange("Field No.", Rec."Field No.");
            if CSVImportError.FindLast() then
                Rec.Validate("Error Line No.", CSVImportError."Error Line No." + 1)
            else
                Rec.Validate("Error Line No.", 1);
        end;
    end;

    procedure InsertError(CSVImportLine: Record "CORE CSV Import Line"; ErrorMessage: Text[250])
    begin
        Rec.Init();
        Rec.Validate("Entry No.", CSVImportLine."Entry No.");
        Rec.Validate("Line No.", CSVImportLine."Line No.");
        Rec.Validate("Field No.", CSVImportLine."Field No.");
        Rec.Validate(Message, ErrorMessage);
        Rec.Insert(true);
    end;
}
