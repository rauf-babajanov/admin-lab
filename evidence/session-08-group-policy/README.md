# Session 8 — Group Policy

**Status:** complete
**Machines:** DC01 for GPO creation and linking, CL01 for proof
**Domain:** `corp.atlas.test`

---

## What was proven

Session 8 proved four normal Group Policy patterns and one failure mode:

| Area | GPO / policy | Scope | Result |
|---|---|---|---|
| Registry restriction | `GPO-USER-RestrictRegedit` | `ATLAS\Users` | Standard users are blocked from Registry Editor |
| IT exemption | `GPO-USER-RestrictRegedit` with Deny on Apply | `SG-Workstation-Admins` | IT staff remain able to open Registry Editor |
| Local administrators | `GPO-COMP-LocalAdmins` | `ATLAS\Computers` | `ATLAS\SG-Workstation-Admins` is added to local Administrators on CL01 |
| Finance drive map | `GPO-USER-DriveMap` | `ATLAS\Users` plus item-level targeting | Finance users get `S:` mapped to `\\DC01\Finance`; non-Finance users do not |
| Security baseline | `GPO-COMP-SecurityBaseline` | `ATLAS\Computers` | Workstation baseline settings apply to CL01 |
| Domain password policy | Default Domain Policy | Domain root | 8-character password rejected after minimum length was set to `12` |

## Key configuration

### Registry restriction and exemption

The registry block was applied broadly to users, then exempted narrowly:

- `Authenticated Users` kept normal Read and Apply permissions.
- `SG-Workstation-Admins` received **Deny** on **Apply group policy** only.
- `ben.hartmann` is a member of `SG-Workstation-Admins`.

This proved the intended model: broad user-side policy, narrow security-filtered exemption.

### Local administrators

`GPO-COMP-LocalAdmins` adds `ATLAS\SG-Workstation-Admins` to the built-in local Administrators group on CL01.

The Group Policy Preferences action is **Update**, not **Replace**. That distinction matters because Replace would remove existing local Administrators members before adding the configured group.

### Finance drive map

`GPO-USER-DriveMap` maps:

```text
S: -> \\DC01\Finance
```

The drive item uses item-level targeting for `SG-Finance-Read`. The important proof is both sides:

- Finance user: `S:` appears.
- Non-Finance user: `S:` does not appear.

### Security baseline

`GPO-COMP-SecurityBaseline` applies simple workstation baseline settings:

| Setting | Value |
|---|---|
| Interactive logon: Machine inactivity limit | `900` seconds |
| Interactive logon: Do not display last user name | Enabled |

These are not complex settings, but they prove computer-side policy processing and match the kind of baseline controls that appear in real endpoint environments.

### Domain password policy

The password-policy exercise exposed a real Group Policy scope trap.

An OU-linked password policy appeared to apply, but domain users could still set short passwords. The fix was to configure the same account-policy settings in Default Domain Policy at the domain root.

Final proven values:

| Setting | Value |
|---|---|
| Minimum password length | `12` |
| Account lockout threshold | `5` |
| Account lockout duration | `15 minutes` |
| Reset account lockout counter after | `15 minutes` |

The final proof was practical: `tom.becker` could no longer change to the same 8-character test password.

See [`../../runbooks/account-policy-applies-but-does-not-enforce.md`](../../runbooks/account-policy-applies-but-does-not-enforce.md).

## Evidence files present

Two HTML Group Policy reports are stored in this folder from Session 8a:

| File | What it proves |
|---|---|
| `gp-regedit-applied-standard-user.html` | Registry restriction applied to a standard user |
| `gp-regedit-exempt-it-staff.html` | IT staff exemption landed through security filtering |

No new Session 8b HTML reports or screenshots are present in this repository. The Session 8b closeout is documented from the completed live work, not from invented files.
