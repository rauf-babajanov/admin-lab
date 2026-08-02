# Password policy appears in gpresult but domain users can still use short passwords

**Applies to:** Active Directory domain password and lockout policy
**Lab context:** `corp.atlas.test`, CL01 domain user testing, DC01 domain controller

---

## Symptom

A password or lockout policy is linked to an OU, `gpresult` shows the GPO as applied, and there are no obvious processing errors.

Domain users can still set passwords that violate the intended policy.

In this lab, `GPO-COMP-PasswordPolicy` was linked to `ATLAS\Computers` first. It appeared to apply cleanly, but `tom.becker` could still change to an 8-character test password.

## Root cause

Domain account policy is read from a GPO linked at the **domain root**.

The same password and lockout settings linked to an OU are not a domain password policy. They affect the local account database on computers in that OU. That makes the failure easy to miss: the GPO can process successfully and still not enforce anything for domain users.

## Confirm it

Use `net accounts` to check what the account database is actually enforcing.

Run it on a domain controller to read the domain account policy:

```powershell
net accounts
```

Run it on a workstation to compare what the local account database sees:

```powershell
net accounts
```

`gpresult` answers "did this GPO apply?" It does not prove that a domain account policy is being enforced.

## Fix

Remove the misplaced OU link so the wrong policy is not left active for local accounts.

Set the password and lockout requirements in a GPO linked at the domain root. In this lab, the settings were placed in **Default Domain Policy**:

| Setting | Value |
|---|---|
| Minimum password length | `12` |
| Account lockout threshold | `5` |
| Account lockout duration | `15 minutes` |
| Reset account lockout counter after | `15 minutes` |

## Verify

After policy refresh, try the same short password again with a domain user.

In this lab, changing `tom.becker` to the same 8-character test password was rejected after the Default Domain Policy was updated. That rejection is the useful evidence: the domain account database, not just GPO processing, enforced the requirement.

## Lesson

This is a scope trap, not a syntax error.

An OU-linked password policy can be real and still be the wrong control. For domain users, prove enforcement at the domain account database layer.
