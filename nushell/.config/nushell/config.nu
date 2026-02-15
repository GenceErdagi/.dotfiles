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

# Add personal bin to PATH
$env.PATH = ($env.PATH | prepend ($env.HOME | path join "bin"))

# Ensure fnm is in PATH
$env.PATH = ($env.PATH | prepend ($env.HOME | path join ".cargo/bin") | prepend ($env.HOME | path join ".local/share/fnm"))

# Bookokrat wrapper - opens in new Windows Terminal tab if in Zellij
# (Zellij's Sixel implementation is buggy, so we bypass it)
def --wrapped bo [...args] {
	if ($env.ZELLIJ? | default "" | str length) > 0 {
		# In Zellij - open book in new Windows Terminal tab
		let book_path = if ($args | is-empty) { $env.PWD } else { $args | first }
		let wt_cmd = $'wt.exe -w 0 nt -d "($env.PWD)" wsl -e bash -c "cd \'($book_path)\' && bookokrat"'
		echo "Opening book in new Windows Terminal tab..."
		nu -c $wt_cmd
	} else {
		# Not in Zellij - use normal mode
		^bookokrat ...$args
	}
}

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
