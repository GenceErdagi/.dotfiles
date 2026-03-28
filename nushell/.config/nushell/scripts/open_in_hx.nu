#!/usr/bin/env nu

const BASE_PORT = 6666

def get-helix-port [] {
    try {
        let session_name = $env.ZELLIJ_SESSION_NAME
        
        if ($session_name == "" or $session_name == "null") {
            return $BASE_PORT
        }
        
        let hash_mod = ($session_name | python3 -c "s=input();h=0;exec('for c in s:h=h*31+ord(c)');print(abs(h)%1000)" | str trim | into int)
        let port = ($BASE_PORT + $hash_mod)
        $port
    } catch {
        $BASE_PORT
    }
}

def main [...files: string] {
    if ($files | is-empty) { return }
    
    let helix_port = (get-helix-port)
    
    # Focus Helix pane via zjide-manager plugin
    try {
        ^zellij pipe -n "focus-helix" -- ""
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
            | str replace "PORT" ($helix_port | into string))
            
        $abs_path + "\n" | do { python3 -c $py_code } | complete | ignore
    }
}
