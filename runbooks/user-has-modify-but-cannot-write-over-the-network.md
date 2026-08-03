# User Has Modify Permission but Cannot Write Over the Network

## Symptom

A Finance user could open `\\DC01\Finance` but could not create a file, even though the NTFS permissions on `C:\Shares\Finance` granted **Modify** to `ATLAS\SG-Finance-Write`.

The folder permissions looked correct, so checking NTFS alone did not explain the failure.

## Environment

- Domain: `corp.atlas.test`
- File server: `DC01`
- Share: `\\DC01\Finance`
- Local path: `C:\Shares\Finance`
- Read group: `ATLAS\SG-Finance-Read`
- Write group: `ATLAS\SG-Finance-Write`
- Write test user: `clara.lange`
- Negative test user: `tom.becker`

## Root Cause

The write group had different permissions at the two layers:

```text
Share permission: Read
NTFS permission:  Modify
Effective network access: Read
```

NTFS Modify was not ignored. Windows evaluated both permission layers, but the share allowed only Read, so the final network access was limited to Read.

When a folder is accessed through a UNC path, both **share permissions** and **NTFS permissions** apply. The more restrictive result wins.

Direct local access to `C:\Shares\Finance` is different because only NTFS permissions apply locally.

## Confirm the Mismatch

Check the share permissions:

```powershell
Get-SmbShareAccess -Name Finance
```

The relevant result was:

```text
ATLAS\SG-Finance-Write   Allow   Read
```

Check the NTFS permissions:

```powershell
icacls C:\Shares\Finance
```

The relevant entry granted Modify:

```text
ATLAS\SG-Finance-Write:(OI)(CI)(M)
```

Where:

- `(OI)` means files inherit the permission.
- `(CI)` means subfolders inherit the permission.
- `(M)` means Modify.

`Get-SmbShareAccess` shows the share layer. `icacls` shows the NTFS layer. Neither command shows the full effective network access by itself.

## Fix

Change the share permission for the write group from **Read** to **Change**:

```powershell
Grant-SmbShareAccess -Name Finance -AccountName "ATLAS\SG-Finance-Write" -AccessRight Change -Force
```

Verify the corrected share permission:

```powershell
Get-SmbShareAccess -Name Finance
```

Expected result:

```text
ATLAS\SG-Finance-Write   Allow   Change
```

The two layers now align:

```text
Share permission: Change
NTFS permission:  Modify
Effective network access: Modify
```

## Verification

Using `clara.lange`, a member of `SG-Finance-Write`:

1. Open `\\DC01\Finance`.
2. Create a file.
3. Edit and save the file.
4. Delete the file.

All write operations succeeded after the share permission was corrected.

No sign-out was required because the resource permission changed. Clara's group membership and security token did not change.

Using `tom.becker`, who belongs to neither Finance group:

1. Open `\\DC01\Finance`.
2. Confirm that access is denied.

The negative test proves that the share is restricted to the intended security groups.

## Diagnostic Rule

When a user can open a network folder but cannot write despite apparently correct NTFS permissions, check both layers:

```powershell
Get-SmbShareAccess -Name Finance
icacls C:\Shares\Finance
```

The core rule is:

```text
Effective network access = Share permissions ∩ NTFS permissions
```

The more restrictive result wins.
