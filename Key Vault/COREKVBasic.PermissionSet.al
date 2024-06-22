namespace Own.Core.Security;

permissionset 50019 "CORE KV Basic"
{
    Caption = 'KV - BASIC', Locked = true;
    Assignable = true;
    Permissions = codeunit "CORE Tenant Key Vault Helper" = X;
}