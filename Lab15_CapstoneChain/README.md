# Lab 15 — Full Chain: One Incident, Start to Finish

**Payload:** [payload.txt](payload.txt) — **instructor/red-team only, do
not show blue team before the debrief**
**Investigation script:** [detect.ps1](detect.ps1)
**Report template:** [incident_report_template.md](incident_report_template.md)
**Cleanup:** [cleanup.ps1](cleanup.ps1)

Every lab so far taught one technique at a time, and told you which lab it
came from. A real incident doesn't come labeled. This capstone runs a
single payload that chains **two techniques you've already built** — Lab
09's persistence and Lab 13's collection/exfiltration — into one incident,
then asks the blue team to reconstruct the whole thing with no hints about
which labs are involved.

## Why this is a tabletop, not just another lab

Nothing here is new red-team technique — it's the same PowerShell from
Lab 09 and Lab 13, unmodified, run back to back. The new skill is entirely
on the blue side: **triage under uncertainty.** Real incidents don't come
with a lab number attached. This is the first exercise where blue has to
figure out *which* techniques are even in play before they can look for
them.

## Setup

1. Complete the Lab 13 setup first: `fake_secrets.txt` on the victim
   Desktop, and `lab_collector.py` running on your isolated lab server.
2. **Instructor/red-team student only:** load [payload.txt](payload.txt)
   onto a Ducky, with `LAB-SERVER` replaced exactly as in Lab 13.
3. Optionally, set up a Wireshark capture per Lab 11 before running the
   payload, if you want the network-forensics angle included too.

## Run it (as a tabletop)

1. **Red team / instructor** runs the payload against the victim VM,
   *without telling the blue team what it contains.*
2. **Blue team** is told only: "A USB device was plugged into this
   machine sometime in the last hour. Investigate." They should NOT see
   `payload.txt` yet.
3. Blue team runs [detect.ps1](detect.ps1) **as Administrator** and works
   through [incident_report_template.md](incident_report_template.md),
   using only what the script shows them.
4. **Debrief together:** compare the filled-in report against
   `payload.txt`. What did blue find? What did they miss? What did they
   correctly infer even without being told which labs were involved?

## Hard mode (instructor's choice)

A few minutes after the main payload runs, additionally run **Lab 14's
payload, completely unmodified**, against the same VM. This simulates the
intruder attempting to cover their tracks before the investigation starts.
Blue team's job gets harder in exactly the way Lab 14 predicted — some
evidence will be gone, and some (the 1102/104 clear-notifications) will
still be there. `detect.ps1`'s Stage 4 section is built for exactly this.

Don't run hard mode the first time a class does this capstone — save it
for a repeat run once students already know what "normal" looks like.

## What blue is actually being graded on

Not "did you find everything" — a well-executed hard-mode run may leave
real, unrecoverable gaps, and that's realistic. Instead:

- Did you build an accurate timeline **from evidence, not guessing**?
- Did you correctly identify what you *couldn't* determine, instead of
  making something up to fill the gap?
- Does your ATT&CK mapping match real evidence, not just a plausible story?
- Is your containment recommendation for each stage specific enough that
  someone else could actually implement it?

## Think about it (debrief questions)

- Which stage was easiest to find? Which was hardest? Does that match
  which stage you'd expect a *real* attacker to invest the most effort in
  hiding?
- If you'd only had access to ONE of the detect scripts from this course
  (pick one), which would you choose, and what would you have completely
  missed?
- This chain used two quiet, no-UAC techniques. If the instructor had
  chained in Lab 08's loud rogue-admin approach instead, would the
  investigation have gotten easier or harder? Why?
- You now have a report template, a consolidated investigation script, and
  a set of ATT&CK IDs you can point to real evidence for. What's still
  missing from your toolkit, compared to what a real SOC analyst has?

## Cleanup

Run [cleanup.ps1](cleanup.ps1). If hard mode (Lab 14) was run, its
log-clearing effects cannot be undone by any script — revert the VM
snapshot for a fully clean slate.

**Next:** [Lab 16 — Close the Door: Preventing HID Injection](../Lab16_HardeningCapstone/).
