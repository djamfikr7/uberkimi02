#!/usr/bin/env python3
"""
Custom HTTP Server with Cache-Busting Headers
Serves Flutter web apps with no-cache headers to prevent stale assets
"""

import http.server
import socketserver
import sys
from pathlib import Path

class NoCacheHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """HTTP handler that disables caching for all responses"""
    
    def end_headers(self):
        # Add cache-busting headers
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()
    
    def log_message(self, format, *args):
        # Cleaner logging
        sys.stderr.write("[%s] %s\n" % (self.log_date_time_string(), format % args))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python cache_bust_server.py <port> [directory]")
        sys.exit(1)
    
    port = int(sys.argv[1])
    directory = sys.argv[2] if len(sys.argv) > 2 else '.'
    
    # Change to the specified directory
    import os
    os.chdir(directory)
    
    # Create server
    handler = NoCacheHTTPRequestHandler
    with socketserver.TCPServer(("", port), handler) as httpd:
        print(f"🚀 Cache-busting server running on port {port}")
        print(f"📂 Serving from: {Path(directory).resolve()}")
        print(f"🌐 Access at: http://localhost:{port}/")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n⏹️  Server stopped")
            sys.exit(0)
