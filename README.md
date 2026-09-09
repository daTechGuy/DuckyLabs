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
| **Beginner** | 00–06 | A controlled lab computer, signed in as a **normal (non-admin) user**. The payloads are harmless and reversible — they open built-in apps or drop a single text file you delete afterward. |
| **Advanced** | 07–11 | A **disposable virtual machine** you have **admin rights** on and can snapshot/revert. These labs install real tooling and make real, privileged changes — see the ground rules below. |

## Lab index

### Beginner track — foundations, then the three teams
| Lab | Team | Technique |
|---|---|---|
| [Lab00_HelloWorld](Lab00_HelloWorld/) | — | Your first payload: open Notepad, type "Hello, World!" + the "why does a computer trust a keyboard?" idea |
| [Lab01_ScriptBasics](Lab01_ScriptBasics/) | — | Read and write DuckyScript yourself: the core commands, and a payload you edit before running |
| [Lab02_TimingDebug](Lab02_TimingDebug/) | — | Fix a payload that's broken on purpose: why `DELAY` matters and how to debug bad timing |
| [Lab03_BeyondRunBox](Lab03_BeyondRunBox/) | — | Open an app without ever touching Win+R — keyboard-only navigation beyond the Run box |
| [Lab04_RedAutomate](Lab04_RedAutomate/) | 🔴 Red | Automate the keyboard: one payload drives several apps instantly, as you |
| [Lab05_BlueTraces](Lab05_BlueTraces/) | 🔵 Blue | Find the breadcrumbs an attack leaves (Run history, recent files, the "too fast" tell) |
| [Lab06_PurpleLoop](Lab06_PurpleLoop/) | 🟣 Purple | Predict → run → detect → improve, on a payload that leaves a real file on disk |

### Advanced track — real attacks in a disposable VM
| Lab | Technique | ATT&CK |
|---|---|---|
| [Lab07_MeetSysmon](Lab07_MeetSysmon/) | Install Sysmon and read your first real process-creation event, before anything's at stake | — |
| [Lab08_RogueAdminShare](Lab08_RogueAdminShare/) | Rogue local admin account + open SMB share of `C:\` | T1136.001, T1098, T1021.002, T1222.001 |
| [Lab09_StagedDownloader](Lab09_StagedDownloader/) | Staged download-and-execute via hidden PowerShell | T1059.001, T1105, T1204.002 |
| [Lab10_StagedFromStorage](Lab10_StagedFromStorage/) | Staged payload run from the Ducky's own onboard storage | T1200, T1059.001, T1204.002 |
| [Lab11_HardeningCapstone](Lab11_HardeningCapstone/) | Prevention, not detection: block new HID devices with a Device Installation Restriction policy | — |

> You should be comfortable with the beginner track before starting Lab 07.
> Labs 08–10 move fast and assume you already understand DuckyScript
> timing, the Run box, how to read simple traces, and — after Lab 07 — how
> to read a Sysmon event.

## Ground rules (read before you plug anything in)

The beginner labs (00–06) are harmless, but the habits matter from day one,
and the advanced labs (07–11) are genuinely dangerous if misused.

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
- **`detect.ps1`** — the blue-team detection script (Labs 05, 06, 07, and
  08–10). Lab 11 is prevention rather than detection, so it ships
  `harden.ps1` and `check.ps1` instead.
- **`cleanup.ps1`** — best-effort reset (where a lab changes something on
  disk).

## Suggested flow (the purple loop)

Every lab — beginner or advanced — is best run through the same loop you learn
in Lab 06:

1. **🔴 Red:** read the payload, *predict* what it will do and what traces it
   will leave, then run it against the lab machine.
2. **🔵 Blue:** run `detect.ps1` (or work the manual checks in the README) to
   find what changed — ideally without being told in advance what the payload
   did.
3. **🟣 Purple:** compare predictions vs. findings, write a detection rule in
   plain English, then ask how you'd change the payload to evade it.
