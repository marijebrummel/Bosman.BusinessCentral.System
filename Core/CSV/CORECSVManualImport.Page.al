namespace Own.Core.CSV;

page 50012 "CORE CSV Manual Import"
{
    ApplicationArea = All;
    Caption = 'CSV Manual Import';
    PageType = StandardDialog;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Import Information';
                InstructionalText = 'Please select which type of CSV you are going to import.';

                field(Type; Type)
                {
                    Caption = 'Type';
                    ToolTip = 'Specifies the value of the Type field.';

                    trigger OnValidate()
                    var
                        CSVImplementation: Interface "CORE CSV Mgt.";
                    begin
                        CSVImplementation := Type;
                        Delimiter := CSVImplementation.SetDelimiter();
                        HasHeader := CSVImplementation.SetHasHeader();
                    end;
                }
                field(Delimiter; Delimiter)
                {
                    Caption = 'Delimiter';
                    ToolTip = 'Specifies the value of the Delimiter field.';
                    Editable = false;
                }
                field("File has Header"; HasHeader)
                {
                    Caption = 'File has Header';
                    ToolTip = 'Specifies the value of the File has Header field.';
                    Editable = false;
                }
            }
        }
    }

    internal procedure GetDelimiter(): Text[1]
    begin
        exit(Delimiter);
    end;

    internal procedure GetHasHeader(): Boolean
    begin
        exit(HasHeader);
    end;

    internal procedure GetType(): Enum "CORE CSV Import Type"
    begin
        exit(Type);
    end;

    var
        Type: Enum "CORE CSV Import Type";
        Delimiter: Text[1];
        HasHeader: Boolean;

}
