# 0002 — Domain promotion to corp.atlas.test

Decision: Promoted DC01 to a new forest, corp.atlas.test (NetBIOS ATLAS), with AD-integrated DNS.

Why: Single-domain forest is sufficient for this lab's scope - no need for multiple domains or trusts. AD-integrated DNS keeps DNS records inside the AD database itself, replicated automatically, which is the standard pattern in real Windows environments.

Deviation from original plan: Session 3 called for a deliberate, temporary internet connection (Default Switch) to activate **Windows Server 2025 Evaluation** before promotion. In practice, the Server evaluation ISO activated locally using its built-in evaluation key with no internet contact required. The internet-exception step was skipped entirely; DC01 has never touched the internet.

**Scope of that finding:** it applies to Windows Server 2025 Evaluation on DC01 only. The Windows 11 Enterprise Evaluation on CL01 behaved differently and did require an activation trip — recorded in `incidents/2026-07-23-cl01-activation-notification.md`. The two are different products with different evaluation behaviour, and this note should not be read as a general statement about evaluation editions.

Added a second UPN suffix, atlaslab.de, alongside corp.atlas.test - so future user accounts can log in as name@atlaslab.de instead of only name@corp.atlas.test. Avoids a painful rename migration later when this lab connects to real cloud services, which reject .test domains.

What I rejected and why: Multiple domains/forest (unnecessary complexity for a single-site lab). Following the internet-activation step as originally planned once evidence showed it wasn't needed - would have been process for its own sake.

How I'll know it was right: SRV lookup resolves DC01 correctly, SYSVOL/NETLOGON shares are live and confirmed functional, DC01 never touched the internet, UPN suffix confirmed present in Get-ADForest output.
