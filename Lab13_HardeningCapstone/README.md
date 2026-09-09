# Lab 13 — Close the Door: Preventing HID Injection

**This is the last lab, and the only one that's proactive instead of
reactive.** Labs 05–12 all answered "how do we catch this after it
happened?" This one answers a different question: **could we have stopped
it from running at all?**

**Scripts:** [harden.ps1](harden.ps1) · [check.ps1](check.ps1) ·
[cleanup.ps1](cleanup.ps1)
**Where to run it:** your disposable advanced-track VM, as **Administrator**.
Reversible via [cleanup.ps1](cleanup.ps1) or a snapshot revert.

---

## The idea: block the device, not just the payload

Every lab in this course relied on one fact: Windows trusts any device that
says "I'm a keyboard." **Device Installation Restriction** policies let an
administrator change that — Windows can be told to refuse to install the
driver for an entire class of device (like HID) unless it's already known,
before a single keystroke is ever possible.

This is the Windows built-in version of the same idea real endpoint-security
products sell as "USB device control": deny by default, allow specific known
hardware.

## The critical safety detail

A blanket "block all HID devices" policy sounds simple but is dangerous to
test carelessly — your VM's own virtual keyboard and mouse are HID devices
too. [harden.ps1](harden.ps1) avoids that trap with one setting:

```
DenyDeviceClassesRetroactive = 0
```

This tells Windows the policy only applies to devices being installed **for
the first time** *after* the policy takes effect. Anything already
installed and working — your VM's keyboard and mouse included — is left
alone. Only a genuinely new device, like a Ducky plugged in for the first
time, gets refused.

> **Still VM-only.** Even with the retroactive-safety setting, only run this
> against your disposable, snapshotted advanced-track VM — never a shared or
> production machine, and never your host.

## Run it

1. Run [harden.ps1](harden.ps1) as Administrator.
2. Unplug your Ducky if it's plugged in, then plug it back in (or plug in
   any Ducky you haven't used on this VM before — "first time on this VM"
   is what matters).
3. Watch what happens: instead of the keyboard identity installing
   silently, you should see a failed/unrecognized device in Device
   Manager, and no payload will run — because the device never became a
   working keyboard in the first place.
4. Run [check.ps1](check.ps1) to confirm the policy is active and to look
   for the driver-installation failure Windows logged.

## Try to break your own defense

Pick any earlier payload — Lab 04's or Lab 08's are good choices — and try
to run it against the now-hardened VM.

(If you built Lab 09's Registry-Run-key persistence or Lab 12's exfil
payload, those are worth retrying here too — does blocking the device at
the door beat *every* later stage, or just the ones that need a fresh USB
enumeration?)

- Does it run at all?
- If you have a *second* Ducky, or can reset the first one's USB identity,
  does re-plugging change anything? (It shouldn't — the policy blocks the
  *class*, not one specific device.)

## Discuss: what this costs

Nothing here is free. Bring these to the debrief:

- **Every genuinely new keyboard or mouse** a student or employee plugs in
  will also be blocked — including their own replacement hardware. A real
  deployment needs an **allow-list** (by exact device ID, not just class)
  for legitimate new hardware, which is ongoing maintenance work.
- This policy is **class-wide**. A more surgical real-world control
  allow-lists specific Vendor ID/Product ID (VID/PID) combinations instead
  — Lab 11's discussion section mentioned this as the harder-to-deploy but
  more precise version of the same idea.
- Prevention and detection aren't a choice between one or the other. This
  control can fail (a misconfigured allow-list, a device that spoofs an
  allowed VID/PID) — which is exactly why Labs 05–12 still matter as a
  second layer.

## The whole course, in one sentence

Labs 00–03 taught you *how* a keyboard is trusted and how to write for one.
Labs 04–06 taught you to think like red, then blue, then both together.
Labs 07–12 took that into a real environment with real logs, real
persistence, and real exfiltration. This lab closes the loop: now that you
know how the attack works and how to catch it, you also know how to stop
it at the door.

## Cleanup

Run [cleanup.ps1](cleanup.ps1) to remove the policy, or revert the VM
snapshot for a full reset.
