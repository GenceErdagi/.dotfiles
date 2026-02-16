# Environment Variables
$env.EDITOR = 'hx'
$env.COLORTERM = 'xterm-256color'
$env.BUN_INSTALL = ($env.HOME | path join ".bun")

# Path Configuration
# We split the path to ensure we can manipulate it as a list, then prepend our new paths
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.HOME | path join "bin"),
    ($env.HOME | path join ".local/bin"),
    ($env.HOME | path join ".cargo/bin"),
    ($env.HOME | path join ".bun/bin"),
    "/snap/bin",
    ($env.HOME | path join ".nvm/versions/node/v24.12.0/bin"),
    ($env.HOME | path join ".local/share/fnm")
] | uniq)

# FNM Setup
if (which fnm | is-not-empty) {
    load-env (fnm env --shell bash
        | lines
        | str replace 'export ' ''
        | str replace -a '"' ''
        | split column "="
        | rename name value
        | where name != "FNM_ARCH" and name != "PATH"
        | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
    )
    
    if ($env | get --optional FNM_MULTISHELL_PATH | is-not-empty) {
        $env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
    }
}

^/home/gence/.local/bin/zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
oh-my-posh init nu --config ~/.config/oh-my-posh/theme.omp.json | save -f ~/.oh-my-posh.nu
