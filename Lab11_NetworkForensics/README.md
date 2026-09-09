# Lab 11 — Network Forensics: Catch This on the Wire

**No payload of its own — this lab is a companion to Lab 10.** Every
detection script so far watches the *victim machine*. This one moves you to
the wire: capture Lab 10's traffic live with Wireshark and find it without
touching a single Windows log.

**Where to run it:** Wireshark on a machine that can see the traffic between
your victim VM and your lab server — the lab server itself, a hub/span port,
or a virtual switch you can mirror in your hypervisor.
**Prerequisite:** Lab 10, run against your isolated lab server.

---

## Why this lab exists

Every blue-team exercise so far has been **host-based**: registry keys,
event logs, files on disk. That's realistic — most detection *is*
host-based — but it also means a students' whole mental model of "how do we
catch this" has been "look at the machine that got hit." Real security
operations also watch the **network**, and for good reason: **Lab 13**
(Collection & Exfiltration) will show you a case where the network call is
the *only* thing worth catching. This lab teaches the skill that makes that
catch possible, before you need it there.

## Setup

1. Get Wireshark (or `tcpdump`/`tshark` if you prefer command line) running
   somewhere that can see traffic between the victim VM and your lab server.
   The simplest setup: run Wireshark **on the lab server itself**, capturing
   its own network interface — you'll see every request that arrives.
2. Start a capture, filtered to keep the noise down:
   ```
   http and ip.addr == <victim VM's IP>
   ```
3. Run **Lab 10's payload** against the victim VM, pointed at this same lab
   server, exactly as that lab describes.
4. Stop the capture once Notepad or `calc.exe` has appeared on the victim.

## Find it

Work through these in Wireshark, using the packet list and **Follow > HTTP
Stream** on the request:

1. **The GET request itself.** Find the `GET /calc.txt HTTP/1.1` request.
   What's the destination IP and port? What time did it arrive, down to the
   second?
2. **The User-Agent header.** PowerShell's `WebClient` and
   `Invoke-WebRequest` both send a distinctive default User-Agent string
   (something like `Mozilla/5.0 (Windows NT...) WindowsPowerShell/...`) —
   very different from a real browser's. Find it in the request headers.
3. **Cleartext.** Lab 10's payload uses plain `http://`, not `https://`.
   Everything — the request, the response, the entire `calc.exe` payload
   bytes — is visible in your capture, unencrypted. Use **File > Export
   Objects > HTTP** to pull the transferred file straight out of the pcap.
4. **Correlate with the host.** Compare the request's timestamp to the
   Sysmon Event ID 3 timestamp Lab 10's `detect.ps1` showed you (if you
   still have that output). They should line up to the second.

## Think about it

- The User-Agent string alone is a strong indicator here. What would it
  take for an attacker to defeat *just* that one signal? (Hint: PowerShell
  lets you set a custom `-UserAgent` on `Invoke-WebRequest`.) Does removing
  one signal make the traffic invisible, or just quieter?
- If Lab 10's payload had used `https://` instead, which of the four things
  you just found would still be visible to a passive network capture, and
  which would disappear behind encryption?
- You needed a specific vantage point (the lab server, or a span port) to
  see this traffic at all. On a real corporate network, where would you put
  that vantage point to see traffic between an infected endpoint and the
  internet? What's the tradeoff of watching at the endpoint (Sysmon, host
  logs) versus watching on the wire?
- Host-based and network-based detection caught the *same event* from two
  completely different angles here. When would one see something the other
  missed entirely?

## Cleanup

Nothing to clean up — this lab only observes traffic, it doesn't touch the
victim VM beyond what Lab 10 already did. Close your Wireshark capture and
discard it (or save it if you want to revisit the pcap later).

**Next:** [Lab 12 — Staged Payload from Onboard USB Storage](../Lab12_StagedFromStorage/).
