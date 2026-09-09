# Lab 03 — Keyboards Don't Need the Run Box

**Every payload so far used `GUI r` (Win+R) to open apps.** That's
convenient for writing payloads — but it's just as convenient for the blue
team, because Win+R leaves a record. This lab shows the same trick,
opening an app, without ever touching the Run box, and sets up a gap you'll
help find in Lab 05.

**Payload:** [payload.txt](payload.txt)
**Where to run it:** a controlled lab computer, normal (non-admin) user.
Harmless — opens Notepad, types one line, opens and cancels a Save dialog
using only the keyboard.

---

## The idea: the Run box is one door, not the only door

A keyboard can drive *any* part of Windows that a mouse can — menus, search,
dialog buttons, window switching. `GUI r` is one convenient shortcut among
many. This payload uses a different one: pressing the **Windows key alone**
opens Start/Search, and typing an app name there launches it too, no Run box
involved at all.

It also shows keyboard-only navigation *inside* a dialog: `Ctrl+S` opens
Notepad's Save dialog, and `TAB` + `ENTER` can dismiss it without a mouse
click and without knowing exactly which button is focused.

## What the payload does

```
GUI                     Press the Windows key alone -> opens Start/Search.
DELAY 500
STRING notepad           Type the app name into Search.
DELAY 300
ENTER                    Launch it. No Win+R anywhere in this sequence.
...
CTRL s                   Open Notepad's Save dialog.
TAB / TAB / TAB / ENTER  Move focus with the keyboard, then activate
                          whatever's focused - here, Cancel.
```

## Run it, then go hunting

1. Run the payload on the lab machine. Confirm Notepad opens and the line
   types normally, and that the Save dialog opens and closes on its own.
2. Now run [Lab 05's detect.ps1](../Lab05_BlueTraces/detect.ps1) — the same
   script that caught Labs 00, 01, 02, and 04.
3. Look specifically at **section 1, the Run-box history.**

## Think about it

- What did the Run-box history show this time, compared to every earlier
  lab? Why?
- The "Recently opened files" breadcrumb (section 2 of `detect.ps1`) —
  does *that* one still catch this payload? What does that tell you about
  relying on a single breadcrumb?
- If a real attacker knew a defender was only watching Win+R history, what
  does this lab suggest they'd do differently? And if you were the
  defender, what would you want to watch instead? (Lab 05's "limits"
  section names two real tools for exactly this problem.)

## Cleanup

Close Notepad and click **Don't Save** if prompted (the Save dialog in the
payload is already cancelled automatically). Nothing else was touched.

**Next:** [Lab 04 — 🔴 Red: Automate the Keyboard](../Lab04_RedAutomate/).
