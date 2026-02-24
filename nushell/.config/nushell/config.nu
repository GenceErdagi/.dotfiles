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
alias zjide = zellij --layout ide
alias zj = zjide
alias c = clear

# Initialize oh-my-posh
source ~/.oh-my-posh.nu
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

source $"($nu.cache-dir)/carapace.nu"
