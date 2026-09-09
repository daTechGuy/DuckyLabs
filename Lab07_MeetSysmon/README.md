# Lab 07 — Meet Sysmon: Read One Real Event Log

**This is the bridge into the advanced track.** Every detection so far
(Labs 05–06) used breadcrumbs a normal user can read and, just as easily,
avoid — Run-box history, a Recent-files list. Starting with Lab 08, the
`detect.ps1` scripts lean on the **Security event log** and **Sysmon**, and
assume you already know how to read them. This lab is where you set that up
and read your very first real event, at low stakes, before anything else is
riding on it.

**Payload:** [payload.txt](payload.txt) — same "open Notepad" idea as Lab 00
**Config:** [sysmonconfig-beginner.xml](sysmonconfig-beginner.xml)
**Where to run it:** your disposable advanced-track VM, as **Administrator**
for setup. This is also where you'll run Labs 08–10, so Sysmon stays
installed for the rest of the advanced track.

---

## Why RunMRU and Recent-files aren't enough

Both of those breadcrumbs live in locations a normal user account can read
*and edit*. They only capture a narrow slice of what happened (what got
typed into one specific box; which files got opened), and — as Lab 03
showed — a payload that avoids the Run box avoids RunMRU entirely.

**Sysmon** (System Monitor, a free Microsoft Sysinternals tool) instead logs
*process creation itself* — what actually ran, its full command line, what
process launched it, and which user ran it — to a log that needs
Administrator access to clear. It's not unbeatable, but it's a real step up
from anything you've used so far.

## Setup (one time, on your advanced-track VM)

1. Download Sysmon from Microsoft's Sysinternals site onto your **VM**
   (never your host machine) and extract it.
2. Copy [sysmonconfig-beginner.xml](sysmonconfig-beginner.xml) next to
   `Sysmon64.exe`. This config deliberately enables **only** Process
   Creation (Event ID 1) — real-world configs watch a dozen+ event types,
   but one is plenty for a first look and keeps the log short enough to
   actually read.
3. From an **elevated** PowerShell/cmd prompt:
   ```
   Sysmon64.exe -accepteula -i sysmonconfig-beginner.xml
   ```
4. Confirm it's running: `Get-Service Sysmon64` should show `Running`.

## Run it

1. Load [payload.txt](payload.txt) onto your Ducky and run it on the VM —
   it just opens Notepad and types one line, same as Lab 00.
2. Run [detect.ps1](detect.ps1) **as Administrator** (Sysmon's log requires
   elevation to read).

## Read the event

Look at the Sysmon Event ID 1 entry `detect.ps1` prints. Find these fields
in the message text:

- **Image** — the actual .exe that ran (`...\notepad.exe`)
- **CommandLine** — the exact command line, including arguments
- **ParentImage** / **ParentCommandLine** — what *launched* notepad.exe
  (this is where you'd see `explorer.exe` for a normal Run-box launch)
- **User** — which account it ran under
- **UtcTime** — precise timestamp

## Think about it

- Compare this one event to what Lab 05's RunMRU check gave you. Which one
  would survive a payload that skips the Run box, like Lab 03's? Which one
  tells you more even when both catch it?
- `ParentImage` shows what launched the process. For everything you've run
  so far, what would you expect that parent to be? What would it look like
  if a process were instead launched by another process quietly, with no
  visible window at all?
- This config only watches Event ID 1. Sysmon can also log network
  connections (ID 3) and file creation (ID 11) — you'll see both referenced
  in Lab 09's detection script. Why do you think a beginner config should
  start with just one event type instead of turning everything on at once?

## Cleanup

Nothing to clean up from the payload itself (close Notepad, don't save).
**Leave Sysmon installed** — Labs 08, 09, and 10 all check its log, and this
setup step is exactly what makes their "if Sysmon is installed" sections
actually show something.

**Next:** [Lab 08 — Rogue Admin Account + Open SMB Share](../Lab08_RogueAdminShare/).
