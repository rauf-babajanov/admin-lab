# Incident — CL01 shutting down hourly, 0xC004F009

**Date:** 2026-07-23
**Machine:** CL01 (Windows 11 Enterprise Evaluation, Hyper-V guest)
**Session context:** between Session 7 and Session 8

---

**What I saw:** CL01, installed the same day, booted into a licensing "Notification" state and shut itself down on an hourly timer. `slmgr /dlv` reported channel `TIMEBASED_EVAL`, License Status `Notification`, Notification Reason `0xC004F009 (grace time expired)`, Remaining Windows rearm count 2, Remaining SKU rearm count 2.

**What I expected:** a freshly installed evaluation client to run uninterrupted on the isolated lab network, with no activation step required.

**What I thought was wrong:** three hypotheses before the right one, in order.

1. *Host sleep.* That the laptop was sleeping on an idle timer and dropping the VM with it, via `AutomaticStopAction`. Falsified immediately — the shutdowns happen while the host is awake and in active use.
2. *The login account.* That logging in as a domain user rather than a local account would change the behaviour. Wrong layer entirely: authentication has no bearing on licensing state.
3. *Evaluation period expired, rebuild required.* That the only clean path was a full VM reinstall plus deletion of the CL01 computer object in AD. Wrong on the facts — the VM was installed the same day — and the most expensive kind of wrong, because it recommended irreversible work on a bad premise.

**What was ACTUALLY wrong:** the installation had never activated. The isolated lab network has no route out, so activation could not complete, and the machine entered the `0xC004F009` notification state with a shutdown timer attached.

I have hit this same day-one behaviour on three separate machines across different hardware and resolved it the same way each time. Recording it here as observed, repeated behaviour — not as a claim about how evaluation licensing works internally.

**How I found out:** read `slmgr /dlv` directly instead of reasoning forward from the symptom. `slmgr /rearm` followed by a reboot did not clear the state, which ruled out the grace-timer path and pointed at activation itself.

**The fix:** a temporary, reversed internet exception, mirroring the pattern the build plan defines for DC01.

1. Moved CL01's network adapter to the Hyper-V Default Switch.
2. `ping 8.8.8.8` failed — the adapter still held its static lab address and ignored the switch's DHCP. Converted IPv4 to DHCP; ping succeeded, confirming external routing.
3. `slmgr /ato` failed with `0x80072EE7` (name not resolved) — DNS still pointed at DC01, which cannot resolve external names. Set DNS temporarily to a public resolver; `ping google.com` succeeded.
4. `slmgr /ato` completed successfully.
5. Returned the adapter to `vSwitch-ATLAS-Internal`, restored static `10.10.20.21/24`, DNS `10.10.20.10`, gateway blank.

**How I know it's fixed:** `slmgr /dlv` reports License Status `Licensed`. The hourly shutdowns stopped. `Test-ComputerSecureChannel` returns True and domain login still works, confirming the round trip did not break the domain join. DNS is back on DC01 — verified rather than assumed, since a client left pointing at a public resolver cannot find its domain controller.

**How I'd spot this faster next time:** run `slmgr /dlv` as the first step on any fresh evaluation VM and read License Status, rather than inferring it from behaviour. Record the evaluation expiry in `CURRENT.md` and in a calendar on install day — the missing date is why this arrived as a surprise. And a symptom at the top of the stack ("the machine shuts down") says nothing about which layer failed; two of the three wrong guesses above came from starting in the middle instead of at the bottom.

**Note on isolation:** this is the only point at which any machine in this lab has reached the internet. The exception was temporary, reversed immediately, and verified as reversed. It is recorded here rather than left implicit — see also `architecture/decisions/0002-domain-promotion-corp-atlas-test.md`, which covers why DC01 never needed the same trip.
