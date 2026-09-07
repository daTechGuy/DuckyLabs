# DuckyLabs — USB HID Injection Labs for Beginners

A hands-on introduction to USB Rubber Ducky (Hak5, DuckyScript 3.0) attacks
**and how to catch them** — built for high-school / entry-level cybersecurity
students with no prior experience. You start by making a Ducky type "Hello,
World!" and build up, one small step at a time, to real attack-and-detect
exercises.

The course is organized around the three teams security professionals talk
about. You'll play all of them:

- 🔴 **Red** — the attacker. Builds and runs payloads.
- 🔵 **Blue** — the defender. Finds the traces an attack left behind.
- 🟣 **Purple** — red and blue working *together* to make detection better.
  This is the whole point: you learn the attacks so you can defend against
  them.

> **Start at Lab 00 and go in order.** Each lab assumes the ones before it.

## Two kinds of lab machine

| Track | Labs | Where you run it |
|---|---|---|
| **Beginner** | 00–03 | A controlled lab computer, signed in as a **normal (non-admin) user**. The payloads are harmless and reversible — they open built-in apps or drop a single text file you delete afterward. |
| **Advanced** | 04–06 | A **disposable virtual machine** you have **admin rights** on and can snapshot/revert. These payloads make real, privileged changes — see the ground rules below. |

## Lab index

### Beginner track — learn the three teams
| Lab | Team | Technique |
|---|---|---|
| [Lab00_HelloWorld](Lab00_HelloWorld/) | — | Your first payload: open Notepad, type "Hello, World!" + the "why does a computer trust a keyboard?" idea |
| [Lab01_RedAutomate](Lab01_RedAutomate/) | 🔴 Red | Automate the keyboard: one payload drives several apps instantly, as you |
| [Lab02_BlueTraces](Lab02_BlueTraces/) | 🔵 Blue | Find the breadcrumbs an attack leaves (Run history, recent files, the "too fast" tell) |
| [Lab03_PurpleLoop](Lab03_PurpleLoop/) | 🟣 Purple | Predict → run → detect → improve, on a payload that leaves a real file on disk |

### Advanced track — real attacks in a disposable VM
| Lab | Technique | ATT&CK |
|---|---|---|
| [Lab04_RogueAdminShare](Lab04_RogueAdminShare/) | Rogue local admin account + open SMB share of `C:\` | T1136.001, T1098, T1021.002, T1222.001 |
| [Lab05_StagedDownloader](Lab05_StagedDownloader/) | Staged download-and-execute via hidden PowerShell | T1059.001, T1105, T1204.002 |
| [Lab06_StagedFromStorage](Lab06_StagedFromStorage/) | Staged payload run from the Ducky's own onboard storage | T1200, T1059.001, T1204.002 |

> You should be comfortable with the beginner track before starting Lab 04.
> The advanced labs move fast and assume you already understand DuckyScript
> timing, the Run box, and how to read simple traces.

## Ground rules (read before you plug anything in)

The beginner labs (00–03) are harmless, but the habits matter from day one,
and the advanced labs (04–06) are genuinely dangerous if misused.

1. **Controlled machines only.** Beginner labs run on the classroom's
   controlled computers. **Advanced labs run only inside a disposable VM**
   (Hyper-V/VMware/VirtualBox) that is **not** domain-joined and **not**
   bridged onto a production network — every advanced payload runs
   `net user /ADD`, changes firewall rules, and/or edits filesystem ACLs.
2. **Snapshot before, revert after (advanced labs).** Take a VM snapshot
   immediately before each advanced run and reset by reverting it, not by
   undoing changes by hand — some actions (bulk ACL grants especially) are
   impractical to cleanly reverse. Each advanced lab ships a best-effort
   `cleanup.ps1`, but treat it as a convenience, not a guarantee.
3. **No production hardware.** Ducky devices flashed with attack payloads
   must be clearly labeled and stored separately from any device a student
   might plug into a personal or production machine.
4. **Written authorization.** Only use these payloads against systems the
   student/instructor owns or has explicit written authorization to test.
   This is standard for any red-team tooling, including classroom use.
5. **You learn attacks to defend against them.** Running the red-team side is
   expected and normal here — you can't build a detection for something you've
   never seen. Keep every payload pointed at the lab, never at classmates,
   the internet, or anything outside the exercise.

## How each lab is structured

Most labs contain:

- **`payload.txt`** — the DuckyScript to load onto the Rubber Ducky.
- **`README.md`** — what it does line by line, in plain language, plus the
  exercise and discussion questions.
- **`detect.ps1`** — the blue-team detection script (labs 02, 03, and all
  advanced labs).
- **`cleanup.ps1`** — best-effort reset (where a lab changes something on
  disk).

## Suggested flow (the purple loop)

Every lab — beginner or advanced — is best run through the same loop you learn
in Lab 03:

1. **🔴 Red:** read the payload, *predict* what it will do and what traces it
   will leave, then run it against the lab machine.
2. **🔵 Blue:** run `detect.ps1` (or work the manual checks in the README) to
   find what changed — ideally without being told in advance what the payload
   did.
3. **🟣 Purple:** compare predictions vs. findings, write a detection rule in
   plain English, then ask how you'd change the payload to evade it.
