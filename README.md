# DuckyLabs — USB HID Injection Student Labs

A series of USB Rubber Ducky (Hak5, DuckyScript 3.0) labs for teaching HID
injection attacks and their detection. Each lab lives in its own folder with
the payload, a walkthrough, and a detection script for the blue-team half of
the exercise.

## Mandatory ground rules

1. **Isolated VM only.** Every payload here runs `net user /ADD`, modifies
   local group membership, changes firewall rules, and/or edits filesystem
   ACLs. Run payloads only inside a disposable VM (Hyper-V/VMware/VirtualBox)
   that is **not** domain-joined and **not** bridged onto a production
   network.
2. **Snapshot before, revert after.** Take a VM snapshot immediately before
   each run. Reset by reverting the snapshot, not by manually undoing the
   payload — some actions (bulk ACL grants in particular) are impractical to
   cleanly reverse by hand. Each lab includes a best-effort `cleanup.ps1`,
   but treat it as a convenience, not a guarantee.
3. **No production hardware.** Ducky devices flashed with these payloads
   must be clearly labeled and stored separately from any device a student
   might plug into a personal or production machine.
4. **Written authorization.** Only use these payloads against systems the
   student/instructor owns or has explicit written authorization to test.
   This is standard for any red-team tooling, including classroom use.

## Lab index

| Lab | Technique | ATT&CK |
|---|---|---|
| [Lab01_RogueAdminShare](Lab01_RogueAdminShare/) | Rogue local admin account + open SMB share of `C:\` | T1136.001, T1098, T1021.002, T1222.001 |
| [Lab02_StagedDownloader](Lab02_StagedDownloader/) | Staged download-and-execute via hidden PowerShell | T1059.001, T1105, T1204.002 |
| [Lab03_StagedFromStorage](Lab03_StagedFromStorage/) | Staged payload run from the Ducky's own onboard storage | T1200, T1059.001, T1204.002 |

## Suggested lab flow (per exercise)

1. **Red side:** student reviews the payload line-by-line, predicts what
   artifacts it will leave, then runs it against the isolated victim VM via
   the Ducky (or a simulated injection if no hardware is available — see
   each lab's README).
2. **Blue side:** student runs `detect.ps1` (or works through the manual
   queries in the lab README) against the victim VM to find what changed,
   without being told in advance what the payload did.
3. **Debrief:** compare what the payload did vs. what detection surfaced.
   Discuss what a real EDR/SIEM rule would need to catch this, and where
   the payload's own weaknesses are (e.g. English-locale dependency on
   `ALT y` for the UAC prompt).
