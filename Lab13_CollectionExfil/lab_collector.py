#!/usr/bin/env python3
"""
DuckyLabs Lab 13 - minimal exfil-collection listener.

FOR THE ISOLATED LAB NETWORK ONLY. Logs the body of any HTTP POST to
/collect, with a timestamp and source IP, to collected.log in the current
directory. Does nothing else - no execution, no file serving, no state
beyond that log file.

Run this on the same lab server used for Lab 10's downloads, on your
isolated lab network. Never expose it to a production network or the
internet.

Usage: python3 lab_collector.py [port]   (default port 8080)
"""
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from datetime import datetime, timezone


class CollectorHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(length).decode('utf-8', errors='replace')
        timestamp = datetime.now(timezone.utc).isoformat()
        with open('collected.log', 'a', encoding='utf-8') as f:
            f.write(f"[{timestamp}] {self.client_address[0]} -> {body}\n")
        print(f"Collected {length} bytes from {self.client_address[0]}")
        self.send_response(200)
        self.end_headers()

    def log_message(self, format, *args):
        pass  # keep console output limited to the print() above


if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    print(f"Lab 13 collector listening on 0.0.0.0:{port}/collect (isolated lab network only)")
    HTTPServer(('0.0.0.0', port), CollectorHandler).serve_forever()
