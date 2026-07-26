<#
.SYNOPSIS
    Creates lab users in Active Directory from a CSV file.

.DESCRIPTION
    Reads FirstName, LastName, Department and Title from a CSV and creates one
    enabled domain user per row.

    Safe to run more than once: a user that already exists is skipped, not
    overwritten and not an error.

    No password is stored in this file. It is entered once at runtime and held
    as a SecureString, so it is never written to disk and never enters git.

.PARAMETER CsvPath
    Path to the source CSV. Required columns:
    FirstName, LastName, Department, Title

.PARAMETER TargetOU
    Distinguished name of the OU new users are created in.

.PARAMETER UpnSuffix
    Login suffix for the UserPrincipalName. Uses the secondary suffix, not the
    forest root, because .test is rejected by cloud identity services.

.EXAMPLE
    .\New-LabUsers.ps1 -CsvPath C:\admin-lab\data\users.csv

.NOTES
    Run on DC01. Requires the ActiveDirectory module.

    Deliberate lab compromise: every account gets the same password and
    ChangePasswordAtLogon is false, so test logons during Group Policy work do
    not hit a password-change wizard. A production provisioning script would
    generate a unique password per user and force the change at first logon.
    This is a documented trade-off, not an oversight.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ })]
    [string]$CsvPath,

    [string]$TargetOU = "OU=Users,OU=ATLAS,DC=corp,DC=atlas,DC=test",

    [string]$UpnSuffix = "atlaslab.de"
)

Import-Module ActiveDirectory -ErrorAction Stop

# Prompted once, held in memory only.
$password = Read-Host -Prompt "Password for all new lab accounts" -AsSecureString

$users   = Import-Csv -Path $CsvPath
$created = 0
$skipped = 0
$failed  = 0

foreach ($user in $users) {

    $sam = "$($user.FirstName).$($user.LastName)".ToLower()
    $upn = "$sam@$UpnSuffix"

    # Get-ADUser with -Filter returns nothing when there is no match.
    # It does not throw, so this is a clean existence test.
    if (Get-ADUser -Filter "SamAccountName -eq '$sam'") {
        Write-Host "SKIP    $sam - already exists" -ForegroundColor Yellow
        $skipped++
        continue
    }

    try {
        New-ADUser `
            -Name                  "$($user.FirstName) $($user.LastName)" `
            -GivenName             $user.FirstName `
            -Surname               $user.LastName `
            -SamAccountName        $sam `
            -UserPrincipalName     $upn `
            -Path                  $TargetOU `
            -AccountPassword       $password `
            -Enabled               $true `
            -Department            $user.Department `
            -Title                 $user.Title `
            -ChangePasswordAtLogon $false `
            -ErrorAction           Stop

        Write-Host "CREATED $sam ($($user.Department))" -ForegroundColor Green
        $created++
    }
    catch {
        Write-Host "FAILED  $sam - $($_.Exception.Message)" -ForegroundColor Red
        $failed++
        continue
    }

    if ($user.Department -eq "Finance") {
        try {
            Add-ADGroupMember -Identity "SG-Finance-Read" -Members $sam -ErrorAction Stop
            Write-Host "        -> SG-Finance-Read" -ForegroundColor Cyan
        }
        catch {
            Write-Host "        -> group add failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Rows: $($users.Count)   Created: $created   Skipped: $skipped   Failed: $failed"
