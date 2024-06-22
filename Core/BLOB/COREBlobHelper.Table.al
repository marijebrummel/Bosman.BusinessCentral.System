namespace Own.Core.Helpers;

using System.Text;

table 50005 "CORE Blob Helper"
{
    Access = Public;
    Extensible = false;

    fields
    {
        field(1; "Code"; Code[1])
        {
            Caption = 'Code', Locked = true;
            DataClassification = SystemMetadata;
        }

        field(2; "Blob"; Blob)
        {
            Caption = 'Blob', Locked = true;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        TemporyNotAllowedErr: Label 'Blob Helper can only be used in a temporary context.', Locked = true;
    begin
        if not IsTemporary() then
            Error(TemporyNotAllowedErr);
    end;

    procedure ReadAsBase64String(): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
    begin
        if Insert(true) then;

        CalcFields("Blob");
        "Blob".CreateInStream(InStr);
        exit(Base64Convert.ToBase64(Instr));
    end;

    procedure ReadAsText(): Text
    var
        Output: Text;
        TextInStream: InStream;
    begin
        if Insert(true) then;

        CalcFields("Blob");
        "Blob".CreateInStream(TextInStream);
        TextInStream.ReadText(Output);
        exit(Output);
    end;

    procedure WriteFromBase64String(Input: Text);
    var
        Base64Convert: Codeunit "Base64 Convert";
        OutStr: OutStream;
        InStr: InStream;
    begin
        Rec."Blob".CreateOutStream(OutStr);
        Base64Convert.FromBase64(Input, OutStr);
        Rec."Blob".CreateInStream(InStr);
    end;

    procedure WriteFromText(Input: Text)
    var
        TextOutStream: OutStream;
    begin
        Rec."Blob".CreateOutStream(TextOutStream);
        TextOutStream.WriteText(Input);
    end;
}
