# Windows Evaluation client will not activate on an isolated network

**Error:** `0xC004F009` — grace time expired
**Applies to:** Windows 11 Enterprise Evaluation, freshly installed, on a network with no route to Microsoft activation servers

---

## Symptom

A newly installed evaluation client boots into a licensing **Notification** state and shuts itself down on an hourly timer. The install may be only hours old.

## Confirm it

Run this first, before reasoning about the symptom:

```powershell
slmgr /dlv
```

Diagnostic in this case:

| Field | Value |
|---|---|
| Channel | `TIMEBASED_EVAL` |
| License Status | `Notification` |
| Notification Reason | `0xC004F009` (grace time expired) |
| Remaining Windows rearm count | 2 |
| Remaining SKU rearm count | 2 |

## Root cause

The installation never activated. An isolated network has no route to Microsoft's activation servers, so activation cannot complete and the machine drops into the `0xC004F009` notification state with a shutdown timer attached.

Observed on three separate machines across different hardware, resolved the same way each time. Recorded as repeated observed behaviour, not as a claim about how evaluation licensing works internally.

## Ruled out — and why each one wastes time

**Host sleep dropping the guest.** Plausible on a laptop hypervisor, and `AutomaticStopAction` is the right place to look for it. Falsified in seconds: the shutdowns occur while the host is awake and in active use.

**The login account.** Domain user versus local user has no bearing on licensing state. Authentication and licensing are different layers — a symptom at the top of the stack says nothing about which layer below it failed.

**Evaluation period expired, rebuild required.** The expensive one. It recommends irreversible work — VM reinstall plus deletion of the computer object in AD — on a bad premise. A machine installed the same day has not exhausted a 90-day evaluation. Check the install date before accepting an expiry theory.

**`slmgr /rearm` alone.** Rearm followed by a reboot does not clear this state. That result is useful: it rules out the grace-timer path and points at activation itself.

## Fix

A temporary internet exception, reversed immediately. Two sub-failures show up along the way — both are expected.

**1.** Move the client's virtual adapter to a switch with external routing (Hyper-V `Default Switch`).

**2.** Confirm external routing:

```powershell
ping 8.8.8.8
```

This fails at first. The adapter still holds its static lab address and ignores the new switch's DHCP. Convert IPv4 to DHCP, then confirm the ping succeeds.

**3.** Attempt activation:

```powershell
slmgr /ato
```

This fails with `0x80072EE7` (name not resolved). DNS still points at the domain controller, which cannot resolve external names. Set DNS temporarily to a public resolver and confirm name resolution works:

```powershell
ping google.com
```

**4.** Run `slmgr /ato` again. It completes.

**5.** Return the adapter to the isolated switch. Restore the static address, DNS pointing at the domain controller, gateway blank.

## Verify

Licensing cleared:

```powershell
slmgr /dlv
```

License Status reports `Licensed`, and the hourly shutdowns stop.

Domain trust survived the round trip:

```powershell
Test-ComputerSecureChannel
```

Returns `True`, and domain login still works.

Resolver is back where it belongs:

```powershell
Get-DnsClientServerAddress
```

**Check this rather than assuming it.** A client left pointing at a public resolver cannot find its domain controller, and will fail authentication for reasons that look nothing like DNS.

## Prevent

Run `slmgr /dlv` as the first step on any fresh evaluation VM and read License Status directly, rather than inferring it from behaviour.

Record the evaluation expiry on install day. A missing date is why this arrives as a surprise rather than as a scheduled task.
