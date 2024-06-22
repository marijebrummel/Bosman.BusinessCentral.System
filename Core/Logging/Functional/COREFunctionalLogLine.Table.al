namespace Own.Core.Logging;

table 50003 "CORE Functional Log Line"
{
    Caption = 'Functional Log Entry Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Process Id"; Guid)
        {
            Caption = 'Process Id';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "User Id"; Text[20])
        {
            Caption = 'User';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Object Type"; enum "CORE Object Type")
        {
            Caption = 'Object Type';
            DataClassification = CustomerContent;
        }
        field(5; "Object No."; Integer)
        {
            Caption = 'Object No.';
            DataClassification = CustomerContent;
        }
        field(6; "Log Type"; Enum "CORE Logging Level")
        {
            Caption = 'Log Type';
            DataClassification = CustomerContent;
        }
        field(7; "Message"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; Created; DateTime)
        {
            Caption = 'Created';
            DataClassification = CustomerContent;
        }
        field(9; "Call Stack"; Blob)
        {
            Caption = 'Call Stack', Locked = true;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Process Id", "Line No.")
        {
            Clustered = true;
        }
    }
}
