#!/usr/bin/env python3
import html
import os
import subprocess
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer

ROOT = os.path.dirname(os.path.abspath(__file__))
PORT = 18080

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self._handle()

    def do_POST(self):
        self._handle()

    def _handle(self):
        parsed = urllib.parse.urlsplit(self.path)
        rel_path = parsed.path or "/"
        if rel_path == "/":
            rel_path = "/index.html"

        safe_rel = os.path.normpath(rel_path.lstrip("/"))
        full_path = os.path.join(ROOT, safe_rel)

        if not os.path.abspath(full_path).startswith(ROOT):
            self.send_error(403)
            return

        if full_path.endswith(".sh") and os.path.isfile(full_path):
            self._run_script(full_path, parsed.query)
            return

        if not os.path.isfile(full_path):
            self.send_error(404)
            return

        content_type = "text/plain; charset=utf-8"
        if full_path.endswith(".html"):
            content_type = "text/html; charset=utf-8"
        elif full_path.endswith(".css"):
            content_type = "text/css; charset=utf-8"

        with open(full_path, "rb") as f:
            body = f.read()

        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _run_script(self, script_path, query):
        req_len = int(self.headers.get("Content-Length", "0") or "0")
        req_body = self.rfile.read(req_len).decode("utf-8", errors="ignore") if req_len > 0 else ""

        env = os.environ.copy()
        env["REQUEST_METHOD"] = self.command
        env["QUERY_STRING"] = req_body if self.command == "POST" else query
        env["CONTENT_TYPE"] = self.headers.get("Content-Type", "")
        env["CONTENT_LENGTH"] = str(req_len)

        try:
            raw = subprocess.check_output(["/bin/bash", script_path], cwd=ROOT, env=env, stderr=subprocess.STDOUT)
            text = raw.decode("utf-8", errors="replace")
        except subprocess.CalledProcessError as e:
            msg = html.escape(e.output.decode("utf-8", errors="replace"))
            body = f"<h1>CGI Error</h1><pre>{msg}</pre>".encode("utf-8")
            self.send_response(500)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        if "\n\n" in text:
            header_block, content = text.split("\n\n", 1)
        else:
            header_block = "Content-type: text/html; charset=UTF-8"
            content = text

        content_type = "text/html; charset=UTF-8"
        for line in header_block.splitlines():
            if line.lower().startswith("content-type:"):
                content_type = line.split(":", 1)[1].strip()
                break

        body = content.encode("utf-8", errors="replace")
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
