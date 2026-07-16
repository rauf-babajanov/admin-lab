# admin-lab

A classic on-premise Windows infrastructure lab: Active Directory, DNS, Group Policy, permissions, PowerShell - built, broken, and fixed on a single machine.

Built as preparation toward the MD-102 (Endpoint Administrator Associate) certification and Windows/Modern Workplace admin work in Germany and the EU.

**Environment:** one ThinkPad T14, Hyper-V, two VMs (a domain controller and a joined Windows 11 client), isolated internal network - no internet, on purpose. Separation between admin and daily use is done through account tiering, not separate hardware.

**Structure:**
- `architecture/decisions/` - every real design choice, with what was rejected and why
- `incidents/` - things that broke, how they were diagnosed, how they were fixed
- `scripts/powershell/` - inspection and provisioning tools written for this lab
- `evidence/` - command output and proof that things actually work
- `notes/` - working notes, not polished

Repo is private until the foundation is solid.
