namespace Own.Core.UI;

using Own.Core.Helpers;
using Own.Core.Azure;
using Own.Core.Logging;
using Own.Core.Security;
using Own.Core.System;
using Own.Core.FTP;
using Own.Core.SOAP;
using Own.Core.Setup;
using Own.Core.CSV;
using Own.Core.FixedLength;
permissionset 50000 "CORE All"
{
    Access = Internal;
    Assignable = false;
    Caption = 'Bomsna Core - All permissions', Locked = true;
    Permissions = codeunit "CORE API Helper" = X,
        codeunit "CORE Azure FileShare Helper" = X,
        codeunit "CORE Azure Blob Helper" = X,
        codeunit "CORE Blob Helper" = X,
        codeunit "CORE BC REST Communication" = X,
        codeunit "CORE Functional Logging Helper" = X,
        codeunit "CORE JSON Helper" = X,
        codeunit "CORE Key Vault Helper" = X,
        codeunit "CORE Progress Bar Helper" = X,
        codeunit "CORE Technical Logging Helper" = X,
        codeunit "CORE Clear Log Entries" = X,
        codeunit "CORE General Helpers" = X,
        codeunit "CORE Install" = X,
        codeunit "CORE FTP Helper" = X,
        codeunit "CORE SOAP Mgt." = X,
        page "CORE BPD Manager" = X,
        page "CORE Functional Log Entries" = X,
        page "CORE Functional Log Entry" = X,
        page "CORE Functional Log Lines" = X,
        page "CORE Job Queue Entries" = X,
        page "CORE Setup" = X,
        page "CORE Technical Log Entries" = X,
        page "CORE Technical Log Entry" = X,
        page "CORE FTP Settings" = X,
        table "CORE Functional Log Entry" = X,
        table "CORE Functional Log Line" = X,
        table "CORE Setup" = X,
        table "CORE Technical Log Entry" = X,
        table "CORE Blob Helper" = X,
        table "CORE FTP Settings" = X,
        tabledata "CORE Functional Log Entry" = RIMD,
        tabledata "CORE Functional Log Line" = RIMD,
        tabledata "CORE Setup" = RIMD,
        tabledata "CORE Technical Log Entry" = RIMD,
        tabledata "CORE Blob Helper" = RIMD,
        tabledata "CORE FTP Settings" = RIMD,
        tabledata "CORE CSV Import Error" = RIMD,
        tabledata "CORE CSV Import Header" = RIMD,
        tabledata "CORE CSV Import Line" = RIMD,
        tabledata "CORE Fixed Length Import Line" = RIMD,
        table "CORE CSV Import Error" = X,
        table "CORE CSV Import Header" = X,
        table "CORE CSV Import Line" = X,
        table "CORE Fixed Length Import Line" = X,
        page "CORE CSV Import" = X,
        page "CORE CSV Import Errors" = X,
        page "CORE CSV Import Matrix" = X,
        page "CORE CSV Imported Files" = X,
        page "CORE CSV Manual Import" = X,
        page "CORE Fixed Length Import Lines" = X,
        page "CORE Functional Errors" = X,
        page "CORE Technical Errors" = X;
}