# Lab 02 — Timing: Why Ducks Fail

**This whole lab is about one idea from Lab 00's "When payloads go wrong"
note: DuckyScript runs blind.** It has no way to check whether Windows has
caught up — it just executes on a schedule you write. Get that schedule
wrong and the payload fails, every time, in the same predictable way.

**Payload:** [payload.txt](payload.txt) — **broken on purpose**
**Where to run it:** a controlled lab computer, normal (non-admin) user.
Harmless even when it fails — worst case is a few stray characters land in
the wrong window.

---

## The one idea: no feedback, only guesses

When you press Win+R yourself, your eyes tell your fingers when the Run box
is actually open before you start typing. The Ducky has no eyes. Every
`DELAY` in a payload is the script author's *guess* at how long Windows will
take to respond — and if that guess is too short, the keystrokes that follow
land wherever focus happens to be, which is usually nowhere useful.

This is why real-world Ducky payloads are often mostly `DELAY` lines: the
attacker (or, here, the lab author) is fighting the computer's own
unpredictable speed, not writing clever code.

## Run the broken version first

1. Load [payload.txt](payload.txt) exactly as it is — every `DELAY` is set
   to `1` (one millisecond).
2. Run it on the lab machine and watch what happens. Likely outcomes: the
   Run box never opens, "notepad" gets typed onto the desktop instead, or
   Notepad opens but the message is garbled or missing.
3. **Write down exactly what went wrong.** Which line's timing broke first?

## Fix it

Open `payload.txt` in a text editor. There are three `DELAY` lines, each
marked with a `REM BUG:` comment explaining what it's waiting for. Raise them
one at a time — try `DELAY 1000` for the first, `DELAY 300` for the second,
`DELAY 800` for the third (these are the same values Lab 00 used, for a
reason: they're known-good on typical lab hardware).

Re-run after each change. Keep a short log:

| Attempt | DELAY 1 (recognize device) | DELAY 2 (Run box) | DELAY 3 (Notepad loads) | Result |
|---|---|---|---|---|
| 1 | 1 | 1 | 1 | fails |
| 2 | ... | ... | ... | ... |

## Think about it

- Which single `DELAY` mattered most for getting *something* to happen at
  all, versus which one mattered most for getting *clean* output?
- Slower/older lab machines need longer delays than fast ones. What problem
  does that create for someone writing a payload meant to run on computers
  they've never seen before?
- `STRING` types instantly once it starts — there's no per-character delay
  by default. Does that change how you think about the "impossibly fast"
  detection tell you'll meet properly in Lab 05?

## Bonus: STRINGLN

`STRING` never presses Enter. If you want text *and* a newline in one line
of script, DuckyScript also has `STRINGLN`, which does both. Try swapping
one `STRING` + `ENTER` pair in your fixed payload for a single `STRINGLN`
line and confirm it behaves the same.

## Cleanup

Close Notepad and click **Don't Save**. Nothing else was touched.

**Next:** [Lab 03 — Keyboards Don't Need the Run Box](../Lab03_BeyondRunBox/).
