#!/usr/bin/env nu

# Yazi-ZX Wrapper (Nushell version)
# Interactive file manager that opens files in Helix

const SELECTION_FILE = "/tmp/yazi_selection"
const CWD_FILE = "/tmp/yazi_cwd"
const OPEN_SCRIPT = "~/.config/nushell/scripts/open_in_hx.nu"

# Main entry point
def main [] {
    # Validate dependencies
    if not (command-exists yazi) {
        print "Error: yazi not found in PATH"
        exit 1
    }
    
    if not (command-exists zellij) {
        print "Error: zellij not found in PATH"
        exit 1
    }
    
    # Enable sidebar mode for Yazi-ZX
    $env.YAZI_IDE_SIDEBAR = "1"
    
    # Store initial path
    mut current_path = $env.PWD
    $env.YAZI_ZX_ROOT = $current_path
    
    # Run Yazi in a loop until user exits without selection
    loop {
        # Clean temp files
        cleanup-temp-files
        
        # Run Yazi with file chooser
        run-yazi $current_path
        
        # Process selection
        let result = (process-selection)
        
        match $result {
            {action: "open", files: $files, cwd: $cwd} => {
                # Update current path for next iteration
                $current_path = $cwd
                
                # Open files in Helix
                open-files-in-helix $files
            }
            {action: "exit"} => {
                break
            }
            _ => {
                print "Unexpected result from Yazi"
                break
            }
        }
    }
    
    cleanup-temp-files
    print "Yazi-ZX exited"
}

# Clean up temporary files
def cleanup-temp-files [] {
    try { rm -f $SELECTION_FILE }
    try { rm -f $CWD_FILE }
}

# Run Yazi file manager
def run-yazi [path: string] {
    ^yazi $path --chooser-file $SELECTION_FILE --cwd-file $CWD_FILE
}

# Process the selection from Yazi
# Returns a record with action and data
def process-selection [] {
    # Check if selection file exists and has content
    if not ($SELECTION_FILE | path exists) {
        return {action: "exit"}
    }
    
    let content = (open $SELECTION_FILE | str trim)
    
    if ($content | is-empty) {
        return {action: "exit"}
    }
    
    let selected_files = ($content | lines | where {|$line| not ($line | is-empty)})
    
    if ($selected_files | is-empty) {
        return {action: "exit"}
    }
    
    # Get the working directory
    let cwd = (get-cwd $selected_files)
    
    return {
        action: "open"
        files: $selected_files
        cwd: $cwd
    }
}

# Get the current working directory from Yazi
def get-cwd [selected_files: list<string>] {
    if ($CWD_FILE | path exists) {
        let cwd_content = (open $CWD_FILE | str trim)
        if not ($cwd_content | is-empty) {
            return $cwd_content
        }
    }
    
    # Fallback: use directory of first selected file
    $selected_files | first | path dirname
}

# Open selected files in Helix
def open-files-in-helix [files: list<string>] {
    let open_script = ($OPEN_SCRIPT | path expand)
    
    if not ($open_script | path exists) {
        print $"Error: Open script not found at ($open_script)"
        return
    }
    
    # Call the open script with selected files
    nu $open_script ...$files
}

# Helper to check if command exists
def command-exists [cmd: string] {
    (which $cmd | length) > 0
}
