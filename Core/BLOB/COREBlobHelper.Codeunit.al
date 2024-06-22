namespace Own.Core.Helpers;

using System.Reflection;
using System.Utilities;
using System.Text;
using Own.Core.Setup;

codeunit 50006 "CORE Blob Helper"
{
    Permissions = tabledata "CORE Setup" = rim;

    procedure ReadText(FromVariant: Variant; FieldNo: Integer): Text
    var
        TempBlob: Record "CORE Blob Helper" temporary;
        DataTypeMgt: Codeunit "Data Type Management";
        FromRecRef: RecordRef;
        FromFieldRef: FieldRef;
        Output: Text;
    begin
        if not FromVariant.IsRecord() or FromVariant.IsRecordRef() then
            exit;

        DataTypeMgt.GetRecordRef(FromVariant, FromRecRef);

        FromFieldRef := FromRecRef.Field(FieldNo);
        FromFieldRef.CalcField();

        TempBlob."Blob" := FromFieldRef.Value();
        Output := TempBlob.ReadAsText();

        exit(Output);
    end;

    procedure ReadBase64(FromVariant: Variant; FieldNo: Integer): Text
    var
        TempBlob: Record "CORE Blob Helper" temporary;
        DataTypeMgt: Codeunit "Data Type Management";
        FromRecRef: RecordRef;
        FromFieldRef: FieldRef;
        Output: Text;
    begin
        if not FromVariant.IsRecord() or FromVariant.IsRecordRef() then
            exit;

        DataTypeMgt.GetRecordRef(FromVariant, FromRecRef);

        FromFieldRef := FromRecRef.Field(FieldNo);
        FromFieldRef.CalcField();

        TempBlob."Blob" := FromFieldRef.Value();
        Output := TempBlob.ReadAsBase64String();

        exit(Output);
    end;

    procedure WriteBase64(ToVariant: Variant; FieldNo: Integer; Input: Text);
    var
        DataTypeMgt: Codeunit "Data Type Management";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        ToRecRef: RecordRef;
        OutStr: OutStream;
    begin
        if not ToVariant.IsRecord() or ToVariant.IsRecordRef() then
            exit;

        DataTypeMgt.GetRecordRef(ToVariant, ToRecRef);

        TempBlob.CreateOutStream(OutStr);
        Base64Convert.FromBase64(Input, OutStr);
        TempBlob.ToRecordRef(ToRecRef, FieldNo);

        ToRecRef.Modify(true);
    end;

    procedure WriteText(ToVariant: Variant; FieldNo: Integer; Input: Text);
    var
        DataTypeMgt: Codeunit "Data Type Management";
        TempBlob: Codeunit "Temp Blob";
        ToRecRef: RecordRef;
        OutStr: OutStream;
    begin
        if not ToVariant.IsRecord() or ToVariant.IsRecordRef() then
            exit;

        DataTypeMgt.GetRecordRef(ToVariant, ToRecRef);

        TempBlob.CreateOutStream(OutStr);
        OutStr.WriteText(Input);

        ToRecRef.Modify(true);
    end;


    procedure TryWriteDownloadFromUrl(ToVariant: Variant; FieldNo: Integer; Url: Text): Boolean
    var
        DataTypeMgt: Codeunit "Data Type Management";
        TempBlob: Codeunit "Temp Blob";
        ToRecRef: RecordRef;
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
    begin
        if not ToVariant.IsRecord() or ToVariant.IsRecordRef() then
            exit(false);

        DataTypeMgt.GetRecordRef(ToVariant, ToRecRef);

        Client.Get(Url, ResponseMessage);
        if not ResponseMessage.IsSuccessStatusCode then
            exit(false);

        ResponseMessage.Content().ReadAs(Instr);
        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, Instr);
        TempBlob.ToRecordRef(ToRecRef, FieldNo);
        ToRecRef.Modify(true);

        exit(true);
    end;
}