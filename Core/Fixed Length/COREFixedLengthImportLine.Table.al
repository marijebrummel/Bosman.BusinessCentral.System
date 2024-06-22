namespace Own.Core.FixedLength;

table 50009 "CORE Fixed Length Import Line"
{
    Caption = 'Fixed Length Import Line';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Data; Text[1024])
        {
            Caption = 'Data';
        }
        field(3; Source; Enum "CORE Fixed Length Source")
        {
            Caption = 'Source';
        }
        field(4; Filename; Text[120])
        {
            Caption = 'Filename';
        }
        field(5; Processed; Boolean)
        {
            Caption = 'Processed';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
