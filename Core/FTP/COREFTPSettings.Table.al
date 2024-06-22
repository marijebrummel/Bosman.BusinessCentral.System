namespace Own.Core.FTP;
using Own.Core.Helpers;
using System.Text;
using System.Utilities;

table 50002 "CORE FTP Settings"
{
    Caption = 'FTP Settings';
    DataClassification = CustomerContent;
    Extensible = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Host; Text[100])
        {
            Caption = 'Host', Locked = true;
        }
        field(3; "User Name KV Name"; Text[30])
        {
            Caption = 'User Name (Name of the Azure KeyVault Secret)';
        }
        field(4; "Password KV Name"; Text[30])
        {
            Caption = 'Password (Name of the Azure KeyVault Secret)';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = "FTP(S)","SFTP";
            OptionCaption = 'FTP(S),SFTP', Locked = true;
        }
        field(6; "Remote Path Upload"; Text[250])
        {
            Caption = 'Remote Path Upload';
        }
        field(7; "Overwrite Existing"; Boolean)
        {
            Caption = 'Overwrite Existing';
        }
        field(8; "Remote Path Download"; Text[250])
        {
            Caption = 'Remote Path Download';
        }
        field(9; "Move After Download"; Boolean)
        {
            Caption = 'Move After Download';
        }
        field(10; "Remote Path Move To"; Text[250])
        {
            Caption = 'Remote Path Move To';
        }
        field(11; "Delete After Download"; Boolean)
        {
            Caption = 'Delete After Download';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    internal procedure TestUpload()
    var
        FTPHelper: Codeunit "CORE FTP Helper";
        Base64DataTxt: Label 'LS0tLS0tLS0tLS0gICAgICAgICAgICAgICAgICAgICAgICAtLS0tLS0tLS0tLQ0KLS0tLS0tIEJ1c2luZXNzIENlbnRyYWwgRlRQIFRlc3QgVXBsb2FkIC0tLS0tLQkNCi0tLS0tLS0tLS0tICAgICAgICAgICAgICAgICAgICAgICAgLS0tLS0tLS0tLS0=', Locked = true;
        UploadSuccessMsg: Label 'Uploaded Successfully';
    begin
        if FTPHelper.Upload(Rec, Base64DataTxt, 'businesscentral_test_upload.txt') then
            Message(UploadSuccessMsg);
    end;

    internal procedure TestDownload()
    var
        FTPHelper: Codeunit "CORE FTP Helper";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        JSONHelper: Codeunit "CORE JSON Helper";
        FileNameList: List of [Text];
        ExtensionList: List of [Text];
        Downloads: JsonToken;
        Download: JsonToken;
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        Base64DataTxt: Label 'LS0tLS0tLS0tLS0gICAgICAgICAgICAgICAgICAgICAgICAtLS0tLS0tLS0tLQ0KLS0tLS0tIEJ1c2luZXNzIENlbnRyYWwgRlRQIFRlc3QgVXBsb2FkIC0tLS0tLQkNCi0tLS0tLS0tLS0tICAgICAgICAgICAgICAgICAgICAgICAgLS0tLS0tLS0tLS0=', Locked = true;
        UploadFailedErr: Label 'Upload Failed';
        DownloadTestFileLbl: Label 'Download Test File';
    begin
        Rec."Remote Path Upload" := Rec."Remote Path Download";
        if FTPHelper.Upload(Rec, Base64DataTxt, 'businesscentral_test_upload.txt') then begin
            FileNameList.Add('businesscentral_test_upload.txt');
            Sleep(2000);
            Downloads := FTPHelper.Download(Rec, FileNameList, ExtensionList);
            if Downloads.IsArray() then
                foreach Download in Downloads.AsArray() do
                    if Download.AsObject().Contains('base64Content') then begin
                        TempBlob.CreateOutStream(OutStr);
                        Base64Convert.FromBase64(JSONHelper.GetTextValue(Download.AsObject(), 'base64Content'), OutStr);
                        TempBlob.CreateInStream(InStr);
                        FileName := JSONHelper.GetTextValue(Download.AsObject(), 'fileName');
                        DownloadFromStream(InStr, DownloadTestFileLbl, '', '', FileName);
                    end;
        end else
            Message(UploadFailedErr);
    end;
}
