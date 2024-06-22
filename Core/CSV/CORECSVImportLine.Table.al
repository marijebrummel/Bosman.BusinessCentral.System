namespace Own.Core.CSV;

table 50007 "CORE CSV Import Line"
{
    Caption = 'CSV Import Lines';
    DataClassification = CustomerContent;
    Extensible = true;

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
            AllowInCustomizations = Never;
        }
        field(4; Type; Enum "CORE CSV Import Type")
        {
            Caption = 'Type';
            AllowInCustomizations = Never;
        }
        field(5; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            AllowInCustomizations = Never;
        }
        field(6; "Field Value"; Text[250])
        {
            Caption = 'Field Value';
            AllowInCustomizations = Never;
        }
        field(7; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            FieldClass = FlowField;
            CalcFormula = count("CORE CSV Import Error" where("Entry No." = field("Entry No."), "Line No." = field("Line No.")));
            Editable = false;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "New","To Process","Partly Processed","Processed","Ignored","Error";
            OptionCaption = 'New,To Process,Partly Processed,Processed,Ignored,Error';
        }
        field(9; "Processing Error"; Boolean)
        {
            Caption = 'Processing Error';
        }
    }
    keys
    {
        key(PK; "Entry No.", "Line No.", "Field No.")
        {
            Clustered = true;
        }
        key(Key1; "Entry No.", "Field No.", "Field Value") { }
    }
}
