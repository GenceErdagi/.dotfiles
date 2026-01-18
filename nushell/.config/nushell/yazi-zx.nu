#!/usr/bin/env nu

# Yazi-ZX Wrapper (Nushell version)
# Replaces yazi-zx bash script

def main [] {
    # Use ZX-specific Yazi config
    $env.YAZI_CONFIG_HOME = $"($env.HOME)/.config/yazi-zx"
    
    # Files to track state
    let selection_file = "/tmp/yazi_selection"
    let cwd_file = "/tmp/yazi_cwd"
    
    # Initial starting path
    mut current_path = $env.PWD
    $env.YAZI_ZX_ROOT = $current_path
    
    loop {
        # Clean temp files
        try { rm -f $selection_file }
        try { rm -f $cwd_file }
        
        # Run Yazi
        # We use `^` to call the external yazi command
        ^yazi $current_path --chooser-file $selection_file --cwd-file $cwd_file
        
        # Check if a file was selected
        if ($selection_file | path exists) {
            let content = (open $selection_file)
            
            # If empty content, user likely quit without selecting
            if ($content | is-empty) {
                break
            }
            
            let selected_files = ($content | lines)
            
            if ($selected_files | is-empty) {
                break
            }
            
            # 1. Update our persistence path
            if ($cwd_file | path exists) {
                let cwd_content = (open $cwd_file | str trim)
                if not ($cwd_content | is-empty) {
                    $current_path = $cwd_content
                } else {
                    # Fallback: Use directory of the first selected file
                    $current_path = ($selected_files | first | path dirname)
                }
            } else {
                # Fallback: Use directory of the first selected file
                $current_path = ($selected_files | first | path dirname)
            }
            
            # 2. Open all files in Helix
            # Call the open_in_hx.nu script
            nu $"($env.HOME)/.config/nushell/open_in_hx.nu" ...$selected_files
            
        } else {
            # No selection file means yazi exited
            break
        }
    }
}
