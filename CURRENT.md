# Current

**Cadence:** 2-3 hours a day. Two sessions a day when they're mechanical (1, 2, 9, 11). Sessions 4, 5, 7, 8, 10 stand alone - leftover time on those days goes to recall, not to the next session.

**Session:** 8 - Group Policy
**Machine:** DC01 / CL01
**Next action:** create one computer-side GPO linked to `ATLAS\Computers` and one user-side GPO linked to `ATLAS\Users`, then prove both applied with `gpresult /r`
**Blocked by:** nothing

---

## Evidence from the last session

Session 6: `New-LabUsers.ps1` created ~25 users from CSV into `ATLAS\Users`, routed Finance users into `SG-Finance-Read`. Second run skipped all existing users cleanly - idempotency proven, not assumed.

Session 7: CL01 joined `corp.atlas.test`. `Test-ComputerSecureChannel` returns True. Computer object moved into `ATLAS\Computers`. Domain login as a normal user confirmed.

Unplanned: CL01 activation incident - see `incidents/2026-07-23-cl01-activation-notification.md`.

## Recall drill - owed

- OU vs security group - what each is for, and how GPO security filtering ties the two together.
- The troubleshooting layer order, from the bottom up, and why starting in the middle costs time.

## Clocks

| Thing | Started | Expires | Action |
|---|---|---|---|
| DC01 - Server 2025 Eval (180 days) | *[read from `slmgr /dlv` on DC01]* | *[fill in]* | `slmgr /rearm` when close, 6 available |
| CL01 - Win11 Enterprise Eval (90 days) | 2026-07-23 | ~2026-10-21 *(confirm with `slmgr /dlv`)* | no extension - reinstall if it lapses |

**Sessions 8-11 must finish inside the CL01 window.** Put both expiry dates in a calendar as well - this file only helps if it is being read.

## Session log

| # | Session | Done | Notes |
|---|---|---|---|
| 1 | Repository live | x | |
| 2 | Hyper-V + isolated network | x | |
| 3 | DC01 + activation + rollback drill | x | Server eval activated without an internet trip |
| 4 | The domain + DNS | x | SRV resolves, secure channel healthy |
| 5 | OUs, groups, users by hand | x | ATLAS OU tree, 3 users, adm-rauf, 2 groups |
| 6 | Users from CSV | x | ~25 users, script safe to run twice |
| 7 | CL01 joins the domain | x | CL01 joined, secure channel True |
| 8 | Group Policy | | |
| 9 | Permissions | | |
| 10 | Break it on purpose | | |
| 11 | PowerShell inspection scripts | | |
