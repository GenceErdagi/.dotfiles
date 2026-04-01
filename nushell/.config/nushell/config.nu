$env.config.show_banner = false

const config_dir = ($nu.config-path | path dirname)

source ($config_dir | path join "prompt.nu")
source ($config_dir | path join "yazi.nu")
source ($config_dir | path join "zellij.nu")
source ($config_dir | path join "completions.nu")
source ($config_dir | path join "aliases.nu")

source ~/.zoxide.nu

# Enable vi mode
$env.config.edit_mode = "vi"

# Cursor shapes matching Helix (line for insert, block for normal)
$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}
