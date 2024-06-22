namespace Own.Core.Security;

using System.Security;

codeunit 50019 "CORE Tenant Key Vault Helper"
{
    [NonDebuggable]
    procedure GetSecretFromTenantKeyVault(SecretName: Text; var SecretValue: Text): Boolean
    var
        KeyVaultSecretProvider: Codeunit "App Key Vault Secret Provider";
    begin
        if KeyVaultSecretProvider.TryInitializeFromCurrentApp() then
            if KeyVaultSecretProvider.GetSecret(SecretName, SecretValue) then
                exit(true);
        exit(false);
    end;
}
