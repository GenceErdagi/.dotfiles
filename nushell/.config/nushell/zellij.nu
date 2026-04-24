def _zellij-cache-path [] {
    $env.HOME | path join ".cache/zellij-sessions-cache.txt"
}

def _zellij-clear-cache [] {
    let p = (_zellij-cache-path)
    if ($p | path exists) { rm $p }
}

def _zellij-get-cached-sessions [] {
    let cache_path = (_zellij-cache-path)
    let ttl = 5sec
    if ($cache_path | path exists) {
        let mtime = (ls $cache_path | get modified | first)
        let age = (date now) - $mtime
        if $age < $ttl {
            return (open $cache_path)
        }
    }
    let output = (zellij ls err> /dev/null | ansi strip)
    $output | save -f $cache_path
    $output
}

def _zellij-session-names [] {
    _zellij-get-cached-sessions 
    | lines 
    | where $it != "" 
    | each { |line| $line | split row " " | first }
}

def --env zjide [...args] {
    let folder_name = $env.PWD | str kebab-case
    if $env.ZELLIJ? == "0" {
        let layout = $env.HOME | path join ".config/zellij/layouts/ide.kdl"
        zellij action override-layout --apply-only-to-active-tab $layout
        return
    }
    let sessions = (_zellij-session-names)
    if $folder_name not-in $sessions {
        let layout = $env.HOME | path join ".config/zellij/layouts/ide.kdl"
        zellij attach --create-background $folder_name ...$args
        zellij --session $folder_name action override-layout $layout
        _zellij-clear-cache
    }
    zellij attach $folder_name
}

def z [...args] {
    let folder_name = $env.PWD | path basename
    zellij attach --create $folder_name ...$args
}

def zellij-ls [] {
    _zellij-get-cached-sessions 
    | lines 
    | where $it != "" 
    | split column " " name status
}

def zellij-cleanup [
    --all (-a) # Delete all sessions regardless of status
] {
    let sessions = (
        _zellij-get-cached-sessions 
        | lines 
        | where $it != ""
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
    _zellij-clear-cache
}

alias zj = zjide
alias zjc = zellij-cleanup
alias zjls = zellij-ls
