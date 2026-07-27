# PowerShell

Tooling written for this lab. Run `Get-Help .\<script>.ps1 -Full` for parameter detail.

---

## New-LabUsers.ps1

Bulk-creates Active Directory user accounts from a CSV file.

### Usage

    .\New-LabUsers.ps1 -CsvPath .\users.csv

| Parameter | Default | Purpose |
|---|---|---|
| `-CsvPath` | *(required)* | Source CSV. Columns: `FirstName`, `LastName`, `Department`, `Title` |
| `-TargetOU` | `OU=Users,OU=ATLAS,DC=corp,DC=atlas,DC=test` | Where accounts are created |
| `-UpnSuffix` | `atlaslab.de` | Login suffix used to build the UPN |

### Behaviour

- Creates one enabled domain account per CSV row
- Builds the UPN from the secondary suffix, not the forest root
- Adds Finance-department accounts to `SG-Finance-Read`
- Prints a per-row result and a created / skipped / failed summary

### Design notes

**Idempotent.** Existing accounts are detected and skipped rather than overwritten or treated as an error. Verified: the first run created the full set, the second skipped all of them cleanly with no duplicates.

**UPN suffix.** Accounts are created as `name@atlaslab.de` rather than `name@corp.atlas.test`. Cloud identity services reject the reserved `.test` TLD, so building the UPN from the forest root would force a rename across every account before any future directory synchronisation.

**Password handling.** No credential is stored in this script. The password is requested once at runtime via `Read-Host -AsSecureString`, held in memory for the duration of the run, and never written to disk.

**Failure isolation.** A failed creation is caught, reported and counted; the run continues to the next row rather than aborting the batch.

### Known lab compromise

All accounts share one password and `ChangePasswordAtLogon` is set to `$false`, so test logons during Group Policy work do not land on a password-change wizard. A production version would generate a unique password per account and force the change at first sign-in. Deliberate trade-off for a disposable lab with fake accounts.

### Requirements

Run on DC01. Requires the `ActiveDirectory` module and rights to create objects in the target OU.
