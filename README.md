# 🖥️ ADmin Lab — ATLAS

**A classic on-premise Windows infrastructure lab** — Active Directory, DNS, Group Policy, permissions, and PowerShell, built and broken on purpose to learn how enterprise Windows environments actually work.

![Status](https://img.shields.io/badge/status-in--progress-blue)
![Target](https://img.shields.io/badge/target-MD--102-orange)
![Domain](https://img.shields.io/badge/domain-corp.atlas.test-lightgrey)

Preparation toward the **MD-102 (Endpoint Administrator Associate)** certification and Windows/Modern Workplace admin roles in Germany and the EU.

---

## Environment

One ThinkPad T14, Hyper-V, two VMs, isolated network — no internet, on purpose.

```text
T14 (laptop)
│
└── vSwitch-ATLAS-Internal   (isolated — no internet)
    ├── T14 itself:  10.10.20.1
    ├── DC01:        10.10.20.10   ← domain controller, AD-integrated DNS
    └── CL01:        10.10.20.21   ← domain-joined Windows 11 client
```

Admin/daily separation is done through **account tiering**, not separate hardware:
`t14-admin` (daily) → `ATLAS\adm-rauf` (domain admin) → `ATLAS\<testuser>` (normal user view)

**One documented exception to the isolation rule.** CL01 was temporarily attached to the Hyper-V Default Switch to complete Windows activation, then returned permanently to the isolated switch. The exception is recorded in full — cause, steps, and reversal — in [`incidents/2026-07-23-cl01-activation-notification.md`](incidents/2026-07-23-cl01-activation-notification.md). Nothing else in this lab has touched the internet.

> The build plan refers to this client as `W11-01`. The machine was built as `CL01`, and the repo uses the real hostname.

---

## Repo structure

| Path | What lives there |
|---|---|
| `architecture/decisions/` | Every real design choice — what was chosen, rejected, and why |
| `incidents/` | Things that broke, how they were diagnosed, how they were fixed |
| `scripts/powershell/` | Inspection and provisioning tools written for this lab |
| `evidence/` | Command output and proof things actually work |

---

## Build log

| # | Session | Status |
|---|---|---|
| 1 | Repository live | ✅ |
| 2 | Hyper-V + isolated network | ✅ |
| 3 | DC01 install + activation + rollback drill | ✅ |
| 4 | Domain + DNS | ✅ |
| 5 | OUs, groups, users by hand | ✅ |
| 6 | Users from CSV (scripted) | ✅ |
| 7 | CL01 joins the domain | ✅ |
| 8 | Group Policy | ⬜ |
| 9 | Permissions | ⬜ |
| 10 | Break it on purpose | ⬜ |
| 11 | PowerShell inspection scripts | ⬜ |

Domain live with AD-integrated DNS and SRV resolution confirmed. OU and group structure in place. ~25 users provisioned from CSV by an idempotent script. Windows 11 client joined, secure channel healthy.

---

*What isn't here yet is as accurate as what is — see the build log above.*
