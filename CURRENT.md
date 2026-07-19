# Current

**Cadence:** 2-3 hours a day. Two sessions a day when they're mechanical (1, 2, 9, 11). Sessions 4, 5, 7, 8, 10 stand alone - leftover time on those days goes to recall, not to the next session.

**Session:** 6 - Users from CSV
**Machine:** T14 (laptop) / DC01
**Next action:** build 25-30 fake user CSV, write New-LabUsers.ps1
**Blocked by:** nothing

---

## Evidence from the last session

Session 5: ATLAS OU tree built (Users, Admins, Computers, Groups). 3 users created by hand. adm-rauf created and added to Domain Admins. SG-Finance-Read and SG-Finance-Write created. Get-ADGroupMember confirmed membership.

## Recall drill - owed from the last session

OU vs security group - what each is for, and how GPO security filtering ties the two together.

## Clocks

| Thing | Started | Expires | Action |
|---|---|---|---|
| DC01 - Server 2025 Eval (180 days) | | | slmgr /rearm when close, 6 available |
| W11-01/CL01 - Win11 Enterprise Eval (90 days) | | | no extension - reinstall if it lapses |

## Session log

| # | Session | Done | Notes |
|---|---|---|---|
| 1 | Repository live | x | |
| 2 | Hyper-V + isolated network | x | |
| 3 | DC01 + activation + rollback drill | x | |
| 4 | The domain + DNS | x | SRV resolves, secure channel healthy |
| 5 | OUs, groups, users by hand | x | ATLAS OU tree, 3 users, adm-rauf, 2 groups |
| 6 | Users from CSV | | |
| 7 | W11-01 joins the domain | x | CL01 joined, secure channel True |
| 8 | Group Policy | | |
| 9 | Permissions | | |
| 10 | Break it on purpose | | |
| 11 | PowerShell inspection scripts | | |
