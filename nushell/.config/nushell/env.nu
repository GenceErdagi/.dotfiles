# Environment Variables
$env.EDITOR = 'hx'
$env.COLORTERM = 'xterm-256color'
$env.BUN_INSTALL = ($env.HOME | path join ".bun")
$env.TERM = "xterm-kitty yazi"
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.HOME | path join "bin"),
    ($env.HOME | path join ".local/bin"),
    ($env.HOME | path join ".cargo/bin"),
    ($env.HOME | path join ".bun/bin"),
    "/snap/bin",
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

# pnpm
$env.PNPM_HOME = "/home/gence/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end
