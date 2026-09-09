# Lab 01 — Read and Write DuckyScript

**Lab 00 ran a payload someone else wrote. This one, you edit yourself.**
Still completely harmless — it opens Notepad and types a few lines. No admin
rights needed, nothing installed, nothing saved to disk.

**Payload:** [payload.txt](payload.txt)
**Where to run it:** a controlled lab computer, signed in as a normal
(non-administrator) user.

---

## The building blocks

DuckyScript is short on purpose — a handful of commands cover almost
everything:

| Command | What it does |
|---|---|
| `REM` | A comment. Ignored when the script runs — it's there for humans reading the file. |
| `DELAY <ms>` | Pause for that many milliseconds before the next line. |
| `STRING <text>` | Type the text exactly as written. Does **not** press Enter. |
| `ENTER` | Press the Enter key on its own. |
| `GUI <key>` | Hold the Windows key and tap another key. `GUI r` = Win+R (Run box). |
| `TAB` | Press Tab — moves keyboard focus to the next control, no typing. |

That's enough to read almost any beginner Ducky payload, including every one
in this repo so far.

## Your job: fill in the TODOs

Open [payload.txt](payload.txt) in a text editor **before** loading it onto
the Ducky. Find the two lines that say `TODO` and replace them:

```
STRING TODO: replace this line with your own name.
STRING TODO: replace this line with today's date.
```

Change them to real `STRING` lines — for example:
```
STRING My name is Alex.
STRING Today is a lab day.
```

This is the whole exercise: you're not just running someone else's script,
you're writing your own lines inside a script that already works.

## Run it

1. Edit `payload.txt` as above.
2. Load it onto your Rubber Ducky.
3. Sign in to the lab computer as a normal user, plug the Ducky in, and
   watch: Notepad opens and your own lines appear, typed by the Ducky.

## Think about it

- `STRING` never presses Enter by itself — why do you think the language
  splits "type this text" and "press this key" into two separate commands
  instead of combining them?
- You used `TAB` at the very end to move focus without typing anything. What
  do you think would happen if you added a second `TAB` after it, then an
  `ENTER`? (You'll get hands-on practice with exactly this idea in Lab 03.)
- Every command you just used is something *you* could physically do with a
  real keyboard. What makes the Ducky different isn't the commands — it's
  the speed and the fact that no human has to be at the keyboard. Keep that
  in mind for Lab 04.

## When payloads go wrong (timing)

You may notice this payload runs a little tighter than Lab 00's — that's
deliberate. If a line arrives before Notepad is ready, it gets typed into
the wrong place or dropped. That's a taste of what Lab 02 covers in full.

## Cleanup

Close Notepad and click **Don't Save**. Nothing else was touched.

**Next:** [Lab 02 — Timing: Why Ducks Fail](../Lab02_TimingDebug/).
