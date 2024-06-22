table 50000 "CORE Technical Log Entry"
{
    Caption = 'Technical Log Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Created; DateTime)
        {
            Caption = 'Created';
        }
        field(3; "Message"; Text[1024])
        {
            Caption = 'Message';
        }
        field(4; Service; Text[80])
        {
            Caption = 'Service';
        }
        field(5; "Status Code"; Integer)
        {
            Caption = 'Status Code';
        }
        field(6; "Status Code Description"; Text[100])
        {
            Caption = 'Status Code Description';
        }
        field(7; Level; Enum "CORE Logging Level")
        {
            Caption = 'Level';
        }
        field(8; Body; Blob)
        {
            Caption = 'Body';
        }
        field(9; Path; Text[1024])
        {
            Caption = 'Path';
        }
        field(10; Request; Blob)
        {
            Caption = 'Request';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(sort; Created)
        {

        }
    }

    trigger OnInsert()
    begin
        Rec."Entry No." := 0;
        Rec.Created := CurrentDateTime();
    end;
}
