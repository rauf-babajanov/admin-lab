Decision: One laptop (ThinkPad T14), Hyper-V, isolated internal network for the whole lab.

Why: One machine handles daily use, admin work, and VM hosting. Separation between roles is done with accounts (t14-admin, ATLAS\adm-rauf), not separate hardware. Hyper-V is built into Windows Pro, no extra licensing, no dual-boot. Isolated network means nothing breaks because of the internet - only because of something I did.

What I rejected and why: A second physical machine (unnecessary cost and complexity for this scope). Proxmox/Linux hypervisor (adds a layer to learn that isn't the certification target). External or Private switch instead of Internal (External leaks the lab onto the real network; Private would cut off my ability to reach the VMs from the laptop at all).

How I'll know it was right: The lab builds and breaks cleanly without host issues, and account tiering alone is enough to demonstrate separation of concerns to a stranger reading the repo.
