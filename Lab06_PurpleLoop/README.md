# Lab 06 — 🟣 Purple: Predict, Run, Detect, Improve

**This is where it all comes together.** Red and blue aren't enemies — they're
two halves of one job. The **purple team** is what you get when the attacker
and the defender work the *same* problem together: the attacker shows what's
possible, the defender learns to catch it, and together they make the
detection sharper. That loop is the real goal of this whole course.

**Payload:** [payload.txt](payload.txt)
**Detection:** [detect.ps1](detect.ps1) · **Cleanup:** [cleanup.ps1](cleanup.ps1)
**Where to run it:** controlled lab computer, normal user. Safe and reversible
— it drops one plain text file on the Desktop, which you delete when done.

---

## What's different about this payload

The labs before this one only *opened apps* or typed text — they didn't
leave a real file behind. This one
uses a single PowerShell command to **write a file to your Desktop**
(`YOU_WERE_HERE.txt`). That's your first taste of a payload that leaves an
*artifact on disk*, which is exactly the kind of thing defenders hunt for. It
still needs no admin rights and is trivially reversible.

## The purple loop (run it with a partner)

Ideally, do this in pairs. One student is 🔴 red, one is 🔵 blue. If you're
solo, play both parts and be honest with yourself.

### Step 1 — 🔴 Red predicts (before running)
Read [payload.txt](payload.txt) line by line. **Write down your predictions**
*before* anything runs:
- What file will appear, and where?
- What will show up in the Run-box history from Lab 05?
- Will this need admin rights? Why or why not?

### Step 2 — 🔴 Red runs it
Load the payload on the Ducky and run it on the lab machine. Confirm the file
appeared on the Desktop.

### Step 3 — 🔵 Blue hunts (ideally without seeing the payload)
The defender runs [detect.ps1](detect.ps1) and tries to answer, from the
output alone:
- What new file appeared, and exactly when?
- Was PowerShell launched from the Run box?
- How much time passed between the command and the file being created?

### Step 4 — 🟣 Purple debrief (together)
Put the predictions next to the findings:
- Did the defender find everything the attacker did? Did they miss anything?
- Did the attacker leave a trace they *didn't* predict?
- **Write ONE detection rule in plain English.** Example:
  > "Alert if a new file appears on any user's Desktop within a few seconds of
  > a `powershell` command showing up in that user's Run-box history."
- Then think like the attacker again: how would you *change the payload* to
  slip past your own rule? (Write to a hidden folder instead of the Desktop?
  Skip the Run box entirely?) That question is the seed of the Advanced track.

## Why this is the important lab

Red alone just breaks things. Blue alone guesses in the dark. **Purple** —
attack and defense talking to each other — is how real security teams turn "we
got hit" into "we'll catch it next time." Everything in the Advanced track
(Labs 07–09) is meant to be run through this same loop: predict, run, detect,
improve.

## Cleanup

Run [cleanup.ps1](cleanup.ps1), or just delete `YOU_WERE_HERE.txt` from the
Desktop. Nothing else was changed.
