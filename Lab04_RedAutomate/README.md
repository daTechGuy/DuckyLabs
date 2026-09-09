# Lab 04 — 🔴 Red: Automate the Keyboard

**You are the attacker now.** In Lab 00 the Ducky said hello. Here you'll
feel what makes it powerful: **one payload can drive the whole computer,
faster than a person can react.**

**Payload:** [payload.txt](payload.txt)
**Where to run it:** controlled lab computer, normal (non-admin) user. Still
completely harmless — it only opens Calculator and Notepad.

---

## The red-team idea: "it runs as you"

The Ducky doesn't break into anything. It types commands into *your* logged-
in session, so **everything it does, it does with your permissions.** If your
account can open an app, delete a file, or visit a website, the Ducky can too
— in about a second, without a click from you.

That's the mindset shift for this lab: the danger isn't some exotic exploit.
It's that a trusted "keyboard" can do *anything the current user can do*, and
do it before anyone in the room can pull the plug.

This lab still uses the Run box (`GUI r`) like Labs 00 and 02, and skips the
Start-Menu-search approach from Lab 03 — worth noticing which trail each
leaves once you get to Lab 05.

## What the payload does

```
GUI r / STRING calc / ENTER       Open the Run box, launch Calculator.
DELAY 600                         Wait, then do it again for a second app.
GUI r / STRING notepad / ENTER    Launch Notepad.
STRING ...                        Type a short note explaining the point.
```

Two apps, one payload, no clicks from you. Now imagine the STRING lines said
something other than `calc` and `notepad`.

## Red-team challenge: change the payload

Editing a payload is how you learn what's possible. Try these (all harmless):

1. **Add a third app.** Copy the `GUI r` / `STRING` / `ENTER` block and
   launch `mspaint` or `winver`.
2. **Change the message** Notepad types.
3. **Break the timing on purpose.** Set the `DELAY` after `GUI r` to `1`
   (basically no wait) and run it. Watch it fail — the typing outruns the
   Run box. This teaches you *why* every real payload is full of `DELAY`
   lines: the attacker is fighting the computer's own speed.

> **Stay in bounds.** Everything you launch in this lab should be a harmless,
> built-in Windows app on the lab machine. Do not point payloads at the
> internet, other people's accounts, or anything outside this classroom. The
> repo's top-level README lists the ground rules — they apply to red-team
> work especially.

## The uncomfortable question

If a payload can open Calculator in one second, what could a *malicious* one
do in that same second as your user account? Write down three things before
you move on. In **Lab 05** you switch to the blue team and start finding the
evidence that attacks like this leave behind.
