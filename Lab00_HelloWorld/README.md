# Lab 00 — Hello, World!

**Your first payload.** Every student starts here, no matter which team you
end up on. It is completely harmless: it opens Notepad and types a message.

**Payload:** [payload.txt](payload.txt)
**Where to run it:** a controlled lab computer, signed in as a normal
(non-administrator) user. No admin rights needed. Nothing is installed or
changed — closing Notepad without saving undoes everything.

---

## The one big idea: your computer trusts keyboards completely

When you plug a keyboard into a computer, the computer never asks "are you
a real keyboard? are you allowed to type?" It just trusts it. Keyboards are
a kind of device called a **HID** — a *Human Interface Device*.

A USB Rubber Ducky is a small gadget that **looks like a USB stick but tells
the computer "I'm a keyboard."** The computer believes it. Then the Ducky
"types" a script of keystrokes — thousands of characters per minute, far
faster than any human — and the computer runs them as if *you* typed them.

That's the whole trick. There's no virus, no hacking of a password. It just
types, and the computer does whatever a keyboard tells it to do. In this lab
that's a friendly hello. In later labs it's more serious — which is exactly
why you need to see how simple the starting point is.

## The three teams (you'll play all of them)

This course is built around the three "teams" security professionals talk
about:

- 🔴 **Red team** — plays the attacker. Builds and runs payloads to see what
  is possible. (Lab 04)
- 🔵 **Blue team** — plays the defender. Hunts for the traces an attack left
  behind, and figures out how to catch it. (Lab 05)
- 🟣 **Purple team** — red and blue working *together*: the attacker explains
  what they did, the defender detects it, and together they make the
  detection better. Purple is the whole point — attack knowledge exists so
  defense can improve. (Lab 06)

You cannot defend against something you don't understand, so every student
learns to run the attack first. That's normal and expected in a controlled
lab like this one.

Before any of that, **Labs 01–03** slow down and build the raw skills every
team needs: reading and writing DuckyScript, fixing broken timing, and
seeing how much a keyboard can do without ever touching the Run box.

## What the payload does, line by line

```
DELAY 1000     Wait 1 second so Windows finishes recognizing the "keyboard".
GUI r          Hold the Windows key and tap R. This opens the Run box - the
               same one you get if you press Win+R yourself.
DELAY 300      Small pause so the Run box is ready.
STRING notepad Type the word "notepad" into the Run box.
ENTER          Press Enter -> Windows launches Notepad.
DELAY 800      Wait for Notepad to actually open before typing into it.
STRING Hello.. Type our message.
ENTER          Press Enter (new line).
STRING Your..  Type a second line.
```

Notice there is no magic here. Every one of these is something you could do
by hand — the Ducky just does it in about a second, without asking you.

## Run it (with the Ducky)

1. Load `payload.txt` onto your Rubber Ducky (Hak5 Payload Studio, or copy
   the compiled `inject.bin` to the Ducky's microSD card — follow your
   class's flashing instructions).
2. Sign in to the lab computer as a normal user.
3. Plug the Ducky in and **watch the screen.** Within a couple of seconds
   Notepad opens and the message appears on its own.

If nothing happens or it opens the wrong thing, the usual cause is timing —
see "When payloads go wrong" below.

## Think about it

- How long did the whole thing take? Could you have stopped it in time?
- The Ducky ran as *you*, with *your* permissions. What could a normal user
  account do on this computer that you would NOT want an attacker doing?
- Nothing here was hidden. In Lab 05 you'll play defender and look for the
  breadcrumbs this left. What breadcrumbs do you think it left already?

## When payloads go wrong (timing)

The single most common reason a Ducky payload fails is **not enough delay**.
If the Ducky starts "typing" before Windows has opened the Run box or before
Notepad has finished loading, the keystrokes land in the wrong place (or
nowhere). If your run misbehaves, try increasing the `DELAY` numbers. You'll
see this theme again in every lab.

## Cleanup

Close Notepad and click **Don't Save**. That's it — this lab leaves nothing
behind on disk.

**Next:** [Lab 01 — Read and Write DuckyScript](../Lab01_ScriptBasics/).
