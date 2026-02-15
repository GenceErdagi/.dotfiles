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

# Ensure fnm is in PATH
$env.PATH = ($env.PATH | prepend ($env.HOME | path join ".cargo/bin") | prepend ($env.HOME | path join ".local/share/fnm"))

load-env (fnm env --shell bash
    | lines
    | str replace 'export ' ''
    | str replace -a '"' ''
    | split column "="
    | rename name value
    | where name != "FNM_ARCH" and name != "PATH"
    | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
)

$env.PATH = ($env.PATH
    | split row (char esep)
    | prepend $"($env.FNM_MULTISHELL_PATH)/bin"
)
$env.config.show_banner = false
alias nvim = nvim-linux-arm64.appimage
alias zjide = zellij --layout ide
oh-my-posh init nu --config ~/.config/oh-my-posh/theme.omp.json
source ~/.zoxide.nu