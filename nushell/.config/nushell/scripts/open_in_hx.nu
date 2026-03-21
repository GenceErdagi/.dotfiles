#!/usr/bin/env nu

const HELIX_TCP_PORT = 6666

def main [...files: string] {
    if ($files | is-empty) { return }
    
    # Focus Helix pane via zjide-manager plugin
    try {
        ^zellij pipe -n "focus-pane" -- "Editor"
    } catch {
        # Fallback
        ^zellij action move-focus right
        ^zellij action move-focus up
    }
    
    for file in $files {
        let abs_path = ($file | path expand | str trim)
        if not ($abs_path | path exists) { continue }
        
        # Send to Helix via TCP
        let py_code = ("import sys, socket; s = socket.socket(socket.AF_INET, socket.SOCK_STREAM); s.connect(('127.0.0.1', PORT)); s.sendall(sys.stdin.read().encode()); s.close()" 
            | str replace "PORT" ($HELIX_TCP_PORT | into string))
            
        $abs_path + "\n" | do { python3 -c $py_code } | ignore
    }
}
