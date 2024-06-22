namespace Own.Core.CSV;

page 50011 "CORE CSV Import Matrix"
{
    ApplicationArea = All;
    Caption = 'CSV Import Matrix';
    PageType = ListPart;
    SourceTable = "CORE CSV Import Line";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    StyleExpr = StatusStyle;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ToolTip = 'Specifies the value of the Error Count field.';
                    DrillDown = true;
                    StyleExpr = StatusStyle;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    StyleExpr = StatusStyle;
                }
                field("Processing Error"; Rec."Processing Error")
                {
                    ToolTip = 'Specifies the value of the Processing Error field.';
                    StyleExpr = StatusStyle;
                }
                #region [Matrix Fields]
                field(FieldValue1; FieldValue[1])
                {
                    CaptionClass = FieldCaption[1];
                    Visible = CaptionCount > 1;
                }
                field(FieldValue2; FieldValue[2])
                {
                    CaptionClass = FieldCaption[2];
                    Visible = CaptionCount > 2;
                }
                field(FieldValue3; FieldValue[3])
                {
                    CaptionClass = FieldCaption[3];
                    Visible = CaptionCount > 3;
                }
                field(FieldValue4; FieldValue[4])
                {
                    CaptionClass = FieldCaption[4];
                    Visible = CaptionCount > 4;
                }
                field(FieldValue5; FieldValue[5])
                {
                    CaptionClass = FieldCaption[5];
                    Visible = CaptionCount > 5;
                }
                field(FieldValue6; FieldValue[6])
                {
                    CaptionClass = FieldCaption[6];
                    Visible = CaptionCount > 6;
                }
                field(FieldValue7; FieldValue[7])
                {
                    CaptionClass = FieldCaption[7];
                    Visible = CaptionCount > 7;
                }
                field(FieldValue8; FieldValue[8])
                {
                    CaptionClass = FieldCaption[8];
                    Visible = CaptionCount > 8;
                }
                field(FieldValue9; FieldValue[9])
                {
                    CaptionClass = FieldCaption[9];
                    Visible = CaptionCount > 9;
                }
                field(FieldValue10; FieldValue[10])
                {
                    CaptionClass = FieldCaption[10];
                    Visible = CaptionCount > 10;
                }
                field(FieldValue11; FieldValue[11])
                {
                    CaptionClass = FieldCaption[11];
                    Visible = CaptionCount > 11;
                }
                field(FieldValue12; FieldValue[12])
                {
                    CaptionClass = FieldCaption[12];
                    Visible = CaptionCount > 12;
                }
                field(FieldValue13; FieldValue[13])
                {
                    CaptionClass = FieldCaption[13];
                    Visible = CaptionCount > 13;
                }
                field(FieldValue14; FieldValue[14])
                {
                    CaptionClass = FieldCaption[14];
                    Visible = CaptionCount > 14;
                }
                field(FieldValue15; FieldValue[15])
                {
                    CaptionClass = FieldCaption[15];
                    Visible = CaptionCount > 15;
                }
                field(FieldValue16; FieldValue[16])
                {
                    CaptionClass = FieldCaption[16];
                    Visible = CaptionCount > 16;
                }
                field(FieldValue17; FieldValue[17])
                {
                    CaptionClass = FieldCaption[17];
                    Visible = CaptionCount > 17;
                }
                field(FieldValue18; FieldValue[18])
                {
                    CaptionClass = FieldCaption[18];
                    Visible = CaptionCount > 18;
                }
                field(FieldValue19; FieldValue[19])
                {
                    CaptionClass = FieldCaption[19];
                    Visible = CaptionCount > 19;
                }
                field(FieldValue20; FieldValue[20])
                {
                    CaptionClass = FieldCaption[20];
                    Visible = CaptionCount > 20;
                }
                field(FieldValue21; FieldValue[21])
                {
                    CaptionClass = FieldCaption[21];
                    Visible = CaptionCount > 21;
                }
                field(FieldValue22; FieldValue[22])
                {
                    CaptionClass = FieldCaption[22];
                    Visible = CaptionCount > 22;
                }
                field(FieldValue23; FieldValue[23])
                {
                    CaptionClass = FieldCaption[23];
                    Visible = CaptionCount > 23;
                }
                field(FieldValue24; FieldValue[24])
                {
                    CaptionClass = FieldCaption[24];
                    Visible = CaptionCount > 24;
                }
                field(FieldValue25; FieldValue[25])
                {
                    CaptionClass = FieldCaption[25];
                    Visible = CaptionCount > 25;
                }
                field(FieldValue26; FieldValue[26])
                {
                    CaptionClass = FieldCaption[26];
                    Visible = CaptionCount > 26;
                }
                field(FieldValue27; FieldValue[27])
                {
                    CaptionClass = FieldCaption[27];
                    Visible = CaptionCount > 27;
                }
                field(FieldValue28; FieldValue[28])
                {
                    CaptionClass = FieldCaption[28];
                    Visible = CaptionCount > 28;
                }
                field(FieldValue29; FieldValue[29])
                {
                    CaptionClass = FieldCaption[29];
                    Visible = CaptionCount > 29;
                }
                field(FieldValue30; FieldValue[30])
                {
                    CaptionClass = FieldCaption[30];
                    Visible = CaptionCount > 30;
                }
                field(FieldValue31; FieldValue[31])
                {
                    CaptionClass = FieldCaption[31];
                    Visible = CaptionCount > 31;
                }
                field(FieldValue32; FieldValue[32])
                {
                    CaptionClass = FieldCaption[32];
                    Visible = CaptionCount > 32;
                }
                field(FieldValue33; FieldValue[33])
                {
                    CaptionClass = FieldCaption[33];
                    Visible = CaptionCount > 33;
                }
                field(FieldValue34; FieldValue[34])
                {
                    CaptionClass = FieldCaption[34];
                    Visible = CaptionCount > 34;
                }
                field(FieldValue35; FieldValue[35])
                {
                    CaptionClass = FieldCaption[35];
                    Visible = CaptionCount > 35;
                }
                field(FieldValue36; FieldValue[36])
                {
                    CaptionClass = FieldCaption[36];
                    Visible = CaptionCount > 36;
                }
                field(FieldValue37; FieldValue[37])
                {
                    CaptionClass = FieldCaption[37];
                    Visible = CaptionCount > 37;
                }
                field(FieldValue38; FieldValue[38])
                {
                    CaptionClass = FieldCaption[38];
                    Visible = CaptionCount > 38;
                }
                field(FieldValue39; FieldValue[39])
                {
                    CaptionClass = FieldCaption[39];
                    Visible = CaptionCount > 39;
                }
                field(FieldValue40; FieldValue[40])
                {
                    CaptionClass = FieldCaption[40];
                    Visible = CaptionCount > 40;
                }
                field(FieldValue41; FieldValue[41])
                {
                    CaptionClass = FieldCaption[41];
                    Visible = CaptionCount > 41;
                }
                field(FieldValue42; FieldValue[42])
                {
                    CaptionClass = FieldCaption[42];
                    Visible = CaptionCount > 42;
                }
                field(FieldValue43; FieldValue[43])
                {
                    CaptionClass = FieldCaption[43];
                    Visible = CaptionCount > 43;
                }
                field(FieldValue44; FieldValue[44])
                {
                    CaptionClass = FieldCaption[44];
                    Visible = CaptionCount > 44;
                }
                field(FieldValue45; FieldValue[45])
                {
                    CaptionClass = FieldCaption[45];
                    Visible = CaptionCount > 45;
                }
                field(FieldValue46; FieldValue[46])
                {
                    CaptionClass = FieldCaption[46];
                    Visible = CaptionCount > 46;
                }
                field(FieldValue47; FieldValue[47])
                {
                    CaptionClass = FieldCaption[47];
                    Visible = CaptionCount > 47;
                }
                field(FieldValue48; FieldValue[48])
                {
                    CaptionClass = FieldCaption[48];
                    Visible = CaptionCount > 48;
                }
                field(FieldValue49; FieldValue[49])
                {
                    CaptionClass = FieldCaption[49];
                    Visible = CaptionCount > 49;
                }
                #endregion [Matrix Fields]
            }
        }
    }

    trigger OnOpenPage()
    var
        CaptionLine: Record "CORE CSV Import Line";
    begin
        CaptionLine.Copy(Rec);
        CaptionLine.SetRange("Line No.", 2);
        if CaptionLine.FindLast() then
            CaptionCount := CaptionLine."Field No.";

        Rec.SetRange("Field No.", 1);
    end;

    trigger OnAfterGetRecord()
    var
        DiabstoreImportLine: Record "CORE CSV Import Line";
    begin
        DiabstoreImportLine.SetRange("Entry No.", Rec."Entry No.");
        DiabstoreImportLine.SetRange("Line No.", Rec."Line No.");
        if DiabstoreImportLine.FindSet() then
            repeat
                FieldValue[DiabstoreImportLine."Field No."] := DiabstoreImportLine."Field Value";
                FieldCaption[DiabstoreImportLine."Field No."] := DiabstoreImportLine."Field Name";
            until DiabstoreImportLine.Next() = 0;

        StatusStyle := 'Standard';
        if Rec."Processing Error" then
            StatusStyle := 'Attention'
        else
            case Rec.Status of
                Rec.Status::Error:
                    StatusStyle := 'Attention';
                Rec.Status::Ignored:
                    StatusStyle := 'StandardAccent';
                Rec.Status::"Partly Processed":
                    StatusStyle := 'Strong';
                Rec.Status::Processed:
                    StatusStyle := 'Favorable';
            end;
    end;

    var
        FieldCaption: array[49] of Text;
        FieldValue: array[49] of Text;
        CaptionCount: Integer;
        StatusStyle: Text;
}
