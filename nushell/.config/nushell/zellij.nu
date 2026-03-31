def --env zjide [...args] {
    let folder_name = ($env.PWD | path basename)
    zellij --layout ide attach --create $folder_name ...$args
}

def zellijj-ls [] {
    zellij ls | ansi strip | lines | split column -c " " name status
}

def zellij-cleanup [
    --all (-a) # Delete all sessions regardless of status
] {
    let sessions = (
        zellij ls 
        | ansi strip 
        | lines 
        | if $all { $in } else { where $it =~ "EXITED" }
        | each { |it| $it | split row " " | first }
    )
    
    if ($sessions | is-empty) {
        print "No sessions to cleanup."
        return
    }

    for session in $sessions {
        print $"Deleting session: ($session)"
        zellij delete-session $session
    }
}

alias zj = zjide
alias zjc = zellij-cleanup
alias zjls = zellijj-ls 
