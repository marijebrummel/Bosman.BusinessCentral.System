namespace Own.Core.Logging;

table 50004 "CORE Functional Log Entry"
{
    Caption = 'Functional Log Entry';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id', Locked = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "User Id"; Text[20])
        {
            Caption = 'User';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; Department; Enum "CORE Department")
        {
            Caption = 'Department';
        }
        field(5; "Last Message"; Text[250])
        {
            Caption = 'Last Message';
            AllowInCustomizations = Always;
        }
        field(6; Warning; Boolean)
        {
            Caption = 'Warning';
            FieldClass = FlowField;
            CalcFormula = exist("CORE Functional Log Line" where("Process Id" = field(id), "Log Type" = filter(Warning)));
            Editable = false;
        }
        field(7; "Error"; Boolean)
        {
            Caption = 'Error';
            FieldClass = FlowField;
            CalcFormula = exist("CORE Functional Log Line" where("Process Id" = field(id), "Log Type" = filter(Error | Critical)));
            Editable = false;
        }
        field(8; Created; DateTime)
        {
            Caption = 'Created';
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
        key(sort; Created)
        {
        }
    }

    trigger OnDelete()
    var
        LogLine: Record "CORE Functional Log Line";
    begin
        LogLine.SetRange("Process Id");
        if LogLine.FindSet() then
            LogLine.DeleteAll(true);
    end;
}
