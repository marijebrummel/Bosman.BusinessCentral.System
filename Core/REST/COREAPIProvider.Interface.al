namespace Own.Core.Helpers;

interface "CORE API Provider"
{
    procedure SetAuthentication(var Client: HttpClient)

    procedure GetBaseURL(): Text

    procedure SetRequestHeaders(var Client: HttpClient)

    procedure SetContentHeaders(var ContentHeaders: HttpHeaders)
}
