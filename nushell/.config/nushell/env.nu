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
    ($env.HOME | path join ".nvm/versions/node/v24.12.0/bin")
] | uniq)

^/home/gence/.local/bin/zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
