#!/usr/bin/env nu

# Yazi-ZX Wrapper (Nushell version)
# Minimalist file manager that opens files in Helix without flashing

# Main entry point
def main [] {
    # Validate dependencies
    if not (command-exists yazi) {
        print "Error: yazi not found in PATH"
        return
    }
    
    if not (command-exists zellij) {
        print "Error: zellij not found in PATH"
        return
    }
    
    # Enable sidebar mode for Yazi-ZX (handled in init.lua)
    $env.YAZI_IDE_SIDEBAR = "1"
    
    # Store initial path
    $env.YAZI_ZX_ROOT = $env.PWD
    
    # Run Yazi directly. 
    # The opener configured in yazi.toml will handle opening files in Helix
    # via open_in_hx.nu without exiting Yazi.
    ^yazi
    
    print "Yazi-ZX exited"
}

# Helper to check if command exists
def command-exists [cmd: string] {
    (which $cmd | length) > 0
}
