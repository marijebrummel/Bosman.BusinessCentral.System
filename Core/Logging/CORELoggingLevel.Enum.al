namespace Own.Core.Logging;

enum 50002 "CORE Logging Level"
{
    Extensible = true;

    value(0; Informational)
    {
        Caption = 'Informational';
    }
    value(1; Warning)
    {
        Caption = 'Warning';
    }
    value(2; Error)
    {
        Caption = 'Error';
    }
    value(3; Critical)
    {
        Caption = 'Critical';
    }
}
