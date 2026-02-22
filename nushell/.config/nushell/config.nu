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
# Initialize oh-my-posh
source ~/.oh-my-posh.nu

source ~/.zoxide.nu
