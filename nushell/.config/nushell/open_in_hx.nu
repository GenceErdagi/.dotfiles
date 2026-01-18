# Open files in Helix via Zellij (Nushell version)
# Replaces open_in_hx.sh

def main [...files] {
    let log_file = "/tmp/yazi_zellij_debug.log"
    
    # Log execution
    $"Script triggered at (date now)\n" | save --append $log_file
    $"Files: ($files)\n" | save --append $log_file
    
    # 1. Move focus from Yazi (left) to Helix (right)
    # We use external zellij command.
    ^zellij action move-focus right
    
    # Ensure we are in the top pane (Helix) if we landed in the bottom one (Terminal)
    ^zellij action move-focus up
    
    # 2. Loop through all files and open them
    for $file in $files {
        # Resolve absolute path
        let abs_path = ($file | path expand)
        
        $"Opening: ($abs_path)\n" | save --append $log_file
        
        # Send commands to Helix via Zellij actions
        # ESC (27)
        ^zellij action write 27
        # :open path
        ^zellij action write-chars $":open ($abs_path)"
        # Enter (13)
        ^zellij action write 13
        
        # Small delay to ensure Helix catches up
        sleep 100ms
    }
}
