def --env zjide [...args] {
    let folder_name = $env.PWD | str kebab-case
    let layout = $env.HOME | path join ".config/zellij/layouts/ide.kdl"
    if $env.ZELLIJ? == "0" {
        zellij action override-layout $layout
        return
    }
    let session_names = (zellij ls -sn | lines )

    if $folder_name not-in $session_names {
        zellij attach --create-background $folder_name ...$args
    }
    zellij --session $folder_name action override-layout $layout
    zellij attach $folder_name
}

def z [...args] {
    let folder_name = $env.PWD | path basename
    zellij attach --create $folder_name ...$args
}

def zellij-ls [] {
    zellij ls | ansi strip | lines | split column " " name status
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
alias zjls = zellij-ls
