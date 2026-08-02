# ADmin Lab — ATLAS

**A classic on-premise Windows infrastructure lab** — Active Directory, DNS, Group Policy, permissions, and PowerShell, built and broken on purpose to learn how enterprise Windows environments actually work.

![Status](https://img.shields.io/badge/status-active-blue)
![Target](https://img.shields.io/badge/target-MD--102-orange)
![Domain](https://img.shields.io/badge/domain-corp.atlas.test-lightgrey)

Built toward the **MD-102 (Endpoint Administrator Associate)** certification and Windows / Modern Workplace administration roles in Germany and the EU.

---

## Environment

One ThinkPad T14, Hyper-V, two VMs, isolated network.

```text
T14 (laptop)
│
└── vSwitch-ATLAS-Internal   (isolated — no gateway)
    ├── T14 itself:  10.10.20.1
    ├── DC01:        10.10.20.10   ← domain controller, AD-integrated DNS
    └── CL01:        10.10.20.21   ← domain-joined Windows 11 client
```

**Why isolated:** with no route out, anything that breaks broke because of a change made inside the lab. That turns every failure into a closed system with a findable cause, which is the entire point of building one.

Admin and daily use are separated by **account tiering**, not by separate hardware:

| Account | Role |
|---|---|
| `t14-admin` | daily laptop login |
| `ATLAS\adm-rauf` | domain admin — lab administration only |
| `ATLAS\<user>` | standard user, used to verify what a normal user actually experiences |

**Activation exception.** Windows evaluation editions require a route to Microsoft's activation servers. CL01 was temporarily attached to the Hyper-V Default Switch to activate, then returned permanently to the isolated switch — cause, steps and reversal recorded in [`runbooks/windows-eval-activation-0xc004f009.md`](runbooks/windows-eval-activation-0xc004f009.md).

> The build plan refers to this client as `W11-01`. The machine was built as `CL01`, and the repo uses the real hostname.

---

## What's here

| Path | Contents |
|---|---|
| [`architecture/decisions/`](architecture/decisions/) | Design choices — what was chosen, what was rejected, and how the choice gets verified |
| [`runbooks/`](runbooks/) | Diagnosed failures, written so the fix is reproducible by someone else |
| [`scripts/powershell/`](scripts/powershell/) | Tooling written for this lab |

---

## Current state

| # | Stage | Status |
|---|---|---|
| 1 | Repository and version control | ✅ |
| 2 | Hyper-V host + isolated virtual network | ✅ |
| 3 | DC01 install, activation, rollback drill | ✅ |
| 4 | Forest promotion + AD-integrated DNS | ✅ |
| 5 | OU structure, security groups, manual user creation | ✅ |
| 6 | Scripted user provisioning from CSV | ✅ |
| 7 | CL01 domain join | ✅ |
| 8 | Group Policy — deployment and failure diagnosis | ✅ |
| 9 | Share and NTFS permissions | ⬜ |
| 10 | Deliberate failure injection and diagnosis | ⬜ |
| 11 | PowerShell inspection tooling | ⬜ |

**Working today:** single-domain forest `corp.atlas.test` with AD-integrated DNS and confirmed SRV resolution. OU tree and `SG-` prefixed security groups in place. 25 user accounts provisioned from CSV by an idempotent script. Windows 11 client joined with a healthy secure channel. Session 8 Group Policy work is complete: user-side restriction with IT exemption, workstation local-admin assignment, Finance drive mapping with item-level targeting, a small security baseline, and the domain password-policy scope trap are documented in [`evidence/session-08-group-policy/`](evidence/session-08-group-policy/).

---

## Verified, not claimed

Every stage marked complete above has evidence behind it — command output, a decision record, or a runbook. Stages not yet marked complete are not described as working.
