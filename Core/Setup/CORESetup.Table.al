namespace Own.Core.Setup;

using Own.Core.Helpers;

table 50001 "CORE Setup"
{
    Caption = 'Core Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[1])
        {
            Caption = 'Code', Locked = true;
            DataClassification = CustomerContent;
        }
        field(2; "Technical Logging Active"; Boolean)
        {
            Caption = 'Technical Logging Active';
            DataClassification = CustomerContent;
        }
        field(3; "Functional Logging Active"; Boolean)
        {
            Caption = 'Functional Logging Active';
            DataClassification = CustomerContent;
        }
        field(4; "BC Connect Api Key KV Name"; Text[30])
        {
            Caption = 'Api Key (Name of the Azure KeyVault Secret)';
            DataClassification = CustomerContent;
        }
        field(5; "Default File Share"; Text[50])
        {
            Caption = 'Default File Share';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Move to BASE extension';
        }
        field(6; "Default Storage Account"; Text[50])
        {
            Caption = 'Default Storage Account';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Move to BASE extension';
        }
        field(7; "Def. St. SAS Token KV Secret"; Text[50])
        {
            Caption = 'Default Storage SAS Token Keyvault Secret Name', Locked = true;
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Moved to BASE extension';
        }
        field(8; "BC Connect API Base URL"; Text[250])
        {
            Caption = 'API Base URL';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    internal procedure Ping()
    var
        APIHelper: Codeunit "CORE API Helper";
        StatusCode: Integer;
        Response: JsonToken;
    begin
        Response := APIHelper.Get("CORE API Provider"::"BC Connect", '/api/Ping', StatusCode);
        Message(Format(Response));
    end;
}
