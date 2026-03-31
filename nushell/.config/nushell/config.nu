def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# Yazi-ZX - Interactive file manager that opens files in Helix
def --env yz [] {
	nu ~/.config/nushell/scripts/yazi-zx.nu
}

$env.config.show_banner = false

# Custom Zellij launcher with folder-based session name (attach or create)
def --env zjide [...args] {
    let folder_name = ($env.PWD | path basename)
    zellij --layout ide attach --create $folder_name ...$args
}

# List Zellij sessions in a nice table
def zellijj-ls [] {
    zellij ls | ansi strip | lines | split column -c " " name status
}

# Cleanup Zellij sessions (defaults to EXITED ones)
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
alias c = clear

# Initilize zoxide 
source ~/.zoxide.nu

# External completers
let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let zoxide_completer = {|spans|
  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
  match $spans.0 {
    z | zi => $zoxide_completer
    __zoxide_z | __zoxide_zi => $zoxide_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config.completions.external = {
  max_results: 20
  enable: true
  completer: $external_completer
}

