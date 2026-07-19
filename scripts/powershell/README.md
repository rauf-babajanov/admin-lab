# scripts/powershell

## New-LabUsers.ps1

Creates Active Directory users in bulk from a CSV, idempotently.

**What it proves:**
- Reads user data (FirstName, LastName, Department, Title) from `users.csv`
- Creates each user in the correct OU (`ATLAS\Users`)
- Routes Finance-department users into `SG-Finance-Read`
- Checks for existing users before creating - safe to run twice with zero
  errors or duplicates (proven: first run created ~25 users, second run
  skipped all of them cleanly)

**Note:** the account password is hardcoded as a plaintext string for lab
simplicity. This is acceptable in an isolated, disposable lab environment
with fake accounts - it would not be an acceptable pattern in production.
