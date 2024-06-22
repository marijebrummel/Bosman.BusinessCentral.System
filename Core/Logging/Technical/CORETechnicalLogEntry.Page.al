page 50001 "CORE Technical Log Entry"
{
    Caption = 'Log Entry';
    PageType = Card;
    SourceTable = "CORE Technical Log Entry";
    UsageCategory = None;
    DataCaptionExpression = Rec.Message;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group("Error Information")
            {
                Caption = 'Error Information';
                Grid(Grid1)
                {
                    Group(Gr1)
                    {
                        ShowCaption = false;

                        field("Message"; Rec.Message)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Message field.';
                            MultiLine = true;
                            ShowCaption = false;
                            Importance = Promoted;
                            RowSpan = 2;
                        }
                        field("Status Code"; Format(Rec."Status Code"))
                        {
                            Caption = 'Status Code';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Status Code field.';
                            //BlankZero = true;
                            Importance = Standard;
                        }
                        field("Status Code Description"; Rec."Status Code Description")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Status Code Description field.';
                            Importance = Standard;
                        }
                        field(Service; Rec.Service)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Service field.';
                            Importance = Standard;
                        }
                        field(Path; Rec.Path)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Path field.';
                            Importance = Standard;
                            MultiLine = true;
                        }
                    }
                }
            }
            group(Meta)
            {
                Caption = 'Metadata';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Importance = Additional;
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                    Importance = Promoted;
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Level field.';
                    Importance = Standard;
                }
            }

            group(ResponseData)
            {
                Caption = 'Error Response';

                usercontrol(Body; "CORE Data Viewer")
                {
                    ApplicationArea = All;

                    trigger AddinLoaded()
                    begin
                        CurrPage.Body.LoadData(ResponseData);
                    end;
                }
            }

            group(RequestData)
            {
                Caption = 'Request';

                usercontrol(Request; "CORE Data Viewer")
                {
                    ApplicationArea = All;

                    trigger AddinLoaded()
                    begin
                        CurrPage.Request.LoadData(RequestData);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        InStr: InStream;
        Line: Text;
    begin
        Clear(ResponseData);
        Rec.CalcFields(Body);
        Rec.Body.CreateInStream(InStr);
        while not InStr.EOS() do begin
            InStr.Read(Line);
            ResponseData += Line;
        end;
        CurrPage.Body.LoadData(ResponseData);

        Clear(RequestData);
        Rec.CalcFields(Request);
        Rec.Request.CreateInStream(InStr);
        while not InStr.EOS() do begin
            InStr.Read(Line);
            RequestData += Line;
        end;
        CurrPage.Body.LoadData(RequestData);
    end;

    var
        ResponseData: Text;
        RequestData: Text;
}
