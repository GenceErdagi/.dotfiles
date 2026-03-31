$env.config.show_banner = false

const config_dir = ($nu.config-path | path dirname)

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

def create_left_prompt [] {
  let dir = ($env.PWD | str replace $env.HOME "~")

  let git = try {
    let branch = (git branch --show-current o+e>| str trim)
    if ($branch | is-empty) {
      ""
    } else {
      let dirty = not (git status --porcelain o+e>| is-empty)
      let icon = if $dirty { "" } else { "" }
      let color = if $dirty { "yellow" } else { "green" }
      $" (ansi $color)($icon) ($branch)(ansi reset)"
    }
  } catch { "" }

  $"(ansi blue) ($dir)(ansi reset)($git)"
}

$env.PROMPT_COMMAND = {|| create_left_prompt }

# Vi mode indicators with visual mode detection
def vi_indicator [] {
  let mode = ($env | get -o EDIT_MODE | default "normal")
  match $mode {
    insert => $"(ansi cyan_bold) INS (ansi reset)"
    normal => $"(ansi green_bold) NOR (ansi reset)"
    _ => $"(ansi magenta_bold) VIS (ansi reset)"
  }
}

$env.PROMPT_INDICATOR_VI_NORMAL = {|| vi_indicator }
$env.PROMPT_INDICATOR_VI_INSERT = {|| vi_indicator }
$env.PROMPT_INDICATOR = {|| $"(ansi green)> (ansi reset)" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi dark_gray)│ (ansi reset)" }

# Right prompt: battery, RAM, date/time
def battery_segment [] {
  try {
    let bat = (ls /sys/class/power_supply/BAT* | first | get name)
    let capacity = (open ($bat | path join "capacity") | str trim | into int)
    let charging = (open ($bat | path join "status") | str trim) == "Charging"
    let icon = if $charging { "" } else {
      if $capacity >= 80 { "" } else {
      if $capacity >= 60 { "" } else {
      if $capacity >= 40 { "" } else {
      if $capacity >= 20 { "" } else { "" }}}}
    }
    let color = if $charging { "green" } else {
      if $capacity >= 60 { "cyan" } else {
      if $capacity >= 20 { "yellow" } else { "red" }}}
    $"(ansi $color)($icon) ($capacity)%(ansi reset)"
  } catch { "" }
}

def ram_segment [] {
  try {
    let meminfo = (open /proc/meminfo | lines | each { ansi strip })
    let total_kb = ($meminfo | find "MemTotal:" | first | parse "MemTotal: {value} kB" | get 0.value | into int)
    let avail_kb = ($meminfo | find "MemAvailable:" | first | parse "MemAvailable: {value} kB" | get 0.value | into int)
    let used_pct = ((($total_kb - $avail_kb) * 100) / $total_kb) | math round
    let icon = "󰍛"
    let color = if $used_pct >= 90 { "red" } else {
      if $used_pct >= 70 { "yellow" } else { "cyan" }}
    $"(ansi $color)($icon) ($used_pct)%(ansi reset)"
  } catch { "" }
}

def time_segment [] {
  let now = (date now)
  let date_part = ($now | format date "%d/%m")
  let time_part = ($now | format date "%H:%M")
  $"(ansi magenta) ($date_part)(ansi reset) (ansi yellow) ($time_part)(ansi reset)"
}

def create_right_prompt [] {
  let battery = (battery_segment)
  let ram = (ram_segment)
  let time = (time_segment)

  let parts = [$battery, $ram, $time] | where ($it | str length) > 0 | str join "  "
  $"(ansi dark_gray)($parts)(ansi reset)"
}

$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
