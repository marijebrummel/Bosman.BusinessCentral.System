namespace Own.Core.Helpers;

using Own.Core.Security;
using Own.Core.Setup;
#pragma warning disable LC0052
codeunit 50008 "CORE BC REST Communication" implements "CORE API Provider"
{
    [NonDebuggable]

    internal procedure SetAuthentication(var Client: HttpClient)
    var
        Setup: Record "CORE Setup";
        KeyVaultHelper: Codeunit "CORE Key Vault Helper";
    begin
        Setup.Get();
        Client.DefaultRequestHeaders.Add('ApiKey', KeyVaultHelper.GetSecretFromKeyVault(Setup."BC Connect Api Key KV Name"));
    end;

    internal procedure GetBaseURL(): Text
    var
        Setup: Record "CORE Setup";
    begin
        Setup.Get();
        exit(Setup."BC Connect API Base URL");
    end;

    internal procedure SetRequestHeaders(var Client: HttpClient)
    begin
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');
    end;

    internal procedure SetContentHeaders(var ContentHeaders: HttpHeaders)
    begin
        ContentHeaders.Add('Content-Type', 'application/json');
    end;
#pragma warning restore LC0052
}
