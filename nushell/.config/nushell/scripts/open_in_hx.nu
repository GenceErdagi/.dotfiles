#!/usr/bin/env nu

# Open files in Helix via Zellij (Nushell version)
# Replaces open_in_hx.sh

const LOG_FILE = "/tmp/yazi_zellij_debug.log"

# Main function to open files in Helix
def main [...files: string] {
    if ($files | is-empty) {
        log-info "No files provided"
        return
    }
    
    log-info $"Script triggered at (date now)"
    log-info $"Files: ($files | str join ', ')"
    
    # Focus Helix pane in Zellij
    focus-helix-pane
    
    # Open each file
    for file in $files {
        let abs_path = ($file | path expand)
        
        if not ($abs_path | path exists) {
            log-info $"⚠ File not found: ($abs_path)"
            continue
        }
        
        log-info $"Opening: ($abs_path)"
        open-file-in-helix $abs_path
    }
    
    log-info "Done opening files"
}

# Focus the Helix pane in Zellij layout
def focus-helix-pane [] {
    # Move focus right from Yazi (left) to Helix (right)
    try {
        ^zellij action move-focus right
        # Ensure we're in the top pane (Helix), not bottom (Terminal)
        ^zellij action move-focus up
        log-info "Focused Helix pane"
    } catch {
        log-info "⚠ Could not focus Helix pane - is Zellij running?"
    }
}

# Open a single file in Helix via Zellij actions
def open-file-in-helix [file: string] {
    # Send ESC to ensure we're in normal mode
    try {
        ^zellij action write 27
        sleep 50ms
        
        # Send :open command
        ^zellij action write-chars $":open \"($file)\""
        sleep 50ms
        
        # Send Enter
        ^zellij action write 13
        sleep 100ms
        
        log-info $"✓ Opened: ($file)"
    } catch {|err|
        log-info $"✗ Error opening ($file): ($err)"
    }
}

# Log to file
def log-info [msg: string] {
    $"($msg)\n" | save --append $LOG_FILE
}
