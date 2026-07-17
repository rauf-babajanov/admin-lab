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
    └── W11-01:      10.10.20.21   ← domain-joined Windows 11 client
```

Admin/daily separation is done through **account tiering**, not separate hardware:
`t14-admin` (daily) → `ATLAS\adm-rauf` (domain admin) → `ATLAS\<testuser>` (normal user view)

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
| 2 | Hyper-V + isolated network | ⬜ |
| 3 | DC01 install + activation + rollback drill | ⬜ |
| 4 | Domain + DNS | ⬜ |
| 5 | OUs, groups, users by hand | ⬜ |
| 6 | Users from CSV (scripted) | ⬜ |
| 7 | W11-01 joins the domain | ⬜ |
| 8 | Group Policy | ⬜ |
| 9 | Permissions | ⬜ |
| 10 | Break it on purpose | ⬜ |
| 11 | PowerShell inspection scripts | ⬜ |

---

*Repo stays private until the foundation is solid.*
