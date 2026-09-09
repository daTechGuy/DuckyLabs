# Lab 05 — 🔵 Blue: Find the Traces

**Now you're the defender.** The red team (you, in Labs 00, 01, 02, and 04)
ran some payloads. This lab flips the chair around: **without being told
exactly what happened, can you find the evidence it left behind?**

**Detection script:** [detect.ps1](detect.ps1)
**Where to run it:** the same lab computer, after any Lab 00, 01, 02, or 04
payload has run. Normal user is fine.

---

## The blue-team idea: attacks leave breadcrumbs

Almost nothing on a computer happens invisibly. When the Ducky opened the Run
box and launched apps, Windows quietly wrote that down in a few places. A
defender's job is knowing *where to look.* You don't need fancy tools for
this first pass — just the breadcrumbs already on the machine.

Three beginner-friendly breadcrumbs:

1. **Run-box history.** Everything typed into Win+R is saved in the registry
   (`HKCU\...\Explorer\RunMRU`). A Ducky that used `GUI r` to launch `calc`
   and `notepad` is recorded there, in order.
2. **Recently used files.** Windows keeps a "Recent" list of files and apps
   that were just opened.
3. **The timing tell.** Humans open things seconds or minutes apart. A Ducky
   opens several apps in the *same second.* When you see a burst of activity
   packed into one or two seconds, suspect a machine did the typing.

## Do the exercise

1. Make sure you've run one of the Lab 00, 01, 02, or 04 payloads on this
   machine.
2. Run `detect.ps1` (right-click → **Run with PowerShell**, or paste it into
   a PowerShell window). It only *reads* information — it changes nothing.
3. Read the three sections of output.

Then answer, in your own words:

- Which apps did the Run-box history show were launched? Does that match the
  payload?
- Look at the timestamps. How close together are they? Would a human plausibly
  do that by hand?
- If you were investigating a computer you *hadn't* attacked yourself, what in
  this output would make you suspicious?

## Do it by hand (optional, but worth it)

Tools hide the lesson. Try finding one breadcrumb yourself:

- Press **Win+R**, type `regedit`, and browse to
  `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`.
  You'll see the exact commands the Ducky typed. (Look, don't change.)

## The limits of this (and where it goes next)

These breadcrumbs are easy to read, but also easy for an attacker to avoid —
a payload that *doesn't* use the Run box won't show up in RunMRU at all. You
already saw that gap in **Lab 03**, where the payload opened Notepad without
ever touching Win+R — go back and run this script after that payload if you
haven't already. Real defenders layer on tools like **Sysmon** and the
**Windows event logs** that record activity the user can't easily erase.
You'll meet those starting in **Lab 07**, and use them throughout the
**Advanced track (Labs 07–16)**. For now, the win is
the instinct: *attacks leave traces, and I know how to start looking.*

Next, **Lab 06** puts red and blue in the same room at the same time — that's
the purple team.
