namespace Own.Core.Security;

using Own.Core.Logging;
codeunit 50002 "CORE Key Vault Helper"
{
    [NonDebuggable]
    procedure GetSecretFromKeyVault(SecretName: Text): Text
    var
        TenantKeyVaultHelper: Codeunit "CORE Tenant Key Vault Helper";
        SecretValue: Text;
    begin
        if TenantKeyVaultHelper.GetSecretFromTenantKeyVault(SecretName, SecretValue) then
            exit(SecretValue)
        else
            LogKeyVaultError(GetLastErrorText(), GetLastErrorCallStack());
    end;

    local procedure LogKeyVaultError(Error: Text; ErrorCallStack: Text)
    var
        FunctionalLoggingHelper: Codeunit "CORE Functional Logging Helper";
        Department: Enum "CORE Department";
        LoggingLevel: Enum "CORE Logging Level";
        Object: Enum "CORE Object Type";
        LogId: Guid;
        RetrieveErr: Label 'Error: %1', Comment = '%1 = LastErrorText';
    begin
        LogId := FunctionalLoggingHelper.CreateLogEntry(Department::IT, 'Keyvault Error');
        FunctionalLoggingHelper.CreateLogEntryLine(LogId, LoggingLevel::Critical, Object::Codeunit, Codeunit::"CORE Key Vault Helper", CopyStr(StrSubstNo(RetrieveErr, Error), 1, 250), ErrorCallStack);
    end;
}