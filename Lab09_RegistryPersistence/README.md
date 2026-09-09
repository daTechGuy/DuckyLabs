# Lab 09 — Persistence: Registry Run Key & Scheduled Task

**Payload:** [payload.txt](payload.txt)
**Target:** Windows 10/11, local (non-domain) machine, **no elevation
required**
**ATT&CK techniques:** T1547.001 (Boot or Logon Autostart Execution:
Registry Run Keys), T1053.005 (Scheduled Task/Job: Scheduled Task)

Lab 08 got persistence by creating a whole new admin account — loud,
privileged, and (as that lab's own "known weaknesses" section says)
trivially caught by any account-creation alert. This lab shows the far
more common real-world approach: persist a small script using mechanisms
Windows gives *any* logged-in user, no admin rights and no UAC prompt
needed at all.

## What it does, line by line

```
DELAY 1000        Wait 1s for the OS to recognize the HID device.
GUI r              Open the Run dialog.
DELAY 300
STRING powershell -NoP -NonI -W Hidden -Exec Bypass "..."
                   One PowerShell one-liner does three things:

                   1. Set-Content ... update.ps1
                      Drops a tiny script in %APPDATA% that just appends
                      the current time to a file in %TEMP% when it runs.

                   2. New-ItemProperty ... CurrentVersion\Run ...
                      Adds an HKCU Run key entry pointing at that script.
                      Everything in this key runs automatically at every
                      logon, for THIS user only - no admin needed because
                      HKCU (current user) is writable by the user already.

                   3. schtasks /Create ... /SC ONLOGON /F
                      ALSO creates a Scheduled Task with the same trigger
                      (at logon) pointing at the same script. Real
                      attackers often lay down more than one persistence
                      mechanism so that removing one doesn't fully evict
                      them - this line demonstrates exactly that habit.
ENTER              Submits the Run dialog. No UAC step anywhere in this
                   payload - notice how much quieter that is than Lab 08.
```

Net effect: the dropped script will run automatically the next time this
user logs on — twice, once from each mechanism — until both are removed.

## Why this matters more than Lab 08's approach

- **No UAC prompt.** Lab 08's `ALT y` step is a visible flash on screen and
  a natural point where an alert user notices something happened. This
  payload has nothing like it.
- **No new account.** Nothing shows up in `Get-LocalUser` or the
  Administrators group. An account-creation alert — the kind Lab 08's
  detection leans on — won't fire.
- **Redundant persistence.** Removing the Run key alone leaves the
  Scheduled Task intact, and vice versa. This is a real, common adversary
  behavior, not a lab contrivance.

## Blue-team exercise

Run [detect.ps1](detect.ps1) on the victim VM after the payload executes.
It checks:

- The HKCU Run key for new entries
- Scheduled tasks created in the last hour
- The dropped script in `%APPDATA%`
- Security event 4698 (scheduled task created)
- **Sysmon Event ID 13** (registry value set) for the Run key — **but only
  if your Sysmon config watches registry events.** Lab 07's beginner config
  deliberately only watched Process Creation. This is exactly the gap that
  choice creates: go back and reload Sysmon with a config that also
  includes `<RegistryEvent onmatch="exclude" />`, then re-run the payload
  and compare.
- PowerShell script block log (event 4104)

## Think about it

- Two persistence mechanisms, one script. If you only checked the Run key
  and found nothing wrong, would you have caught this? What does that say
  about checking just one location?
- The dropped script itself does nothing malicious in this lab — but the
  *mechanism* is identical to how real backdoors, cryptominers, and
  ransomware droppers persist. What would change if `update.ps1`'s content
  were different?
- Lab 07 asked why a beginner Sysmon config should start narrow. Now you've
  seen the cost of that choice firsthand — did widening it feel like a big
  change, or a small one?

## Cleanup

Run [cleanup.ps1](cleanup.ps1) — removes the Run key entry, the scheduled
task, the dropped script, and the file it wrote, if it already ran. Fully
reversible; a snapshot revert is still the cleanest option if you're unsure.

**Next:** [Lab 10 — Staged Download-and-Execute](../Lab10_StagedDownloader/).
