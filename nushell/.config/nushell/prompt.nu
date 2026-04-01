# Nushell prompt with Nerd Fonts, vi mode, battery, ram, git, time
# Normal = ▮ (green), Insert = │ (cyan)

const config_dir = ($nu.config-path | path dirname)
const segments_dir = ($config_dir | path join "segments")

source ($segments_dir | path join "battery.nu")
source ($segments_dir | path join "ram.nu")
source ($segments_dir | path join "git.nu")
source ($segments_dir | path join "time.nu")
source ($segments_dir | path join "dir.nu")

# ── Left Prompt ──
def create_left_prompt [] {
  let dir = (dir_segment)
  let git = (git_segment)
  $"($dir)($git)"
}

# ── Right Prompt ──
def create_right_prompt [] {
  let battery = (battery_segment)
  let ram = (ram_segment)
  let time = (time_segment)

  let parts = [$battery, $ram, $time] | where ($it | str length) > 0 | str join "  "
  $"(ansi dark_gray)($parts)(ansi reset)"
}

# ── Vi Mode Indicators ──
def vi_indicator [] {
  let mode = ($env | get -o EDIT_MODE | default "normal")
  match $mode {
    insert => $"(ansi cyan_bold) INS (ansi reset)"
    normal => $"(ansi green_bold) NOR (ansi reset)"
    _ => $"(ansi magenta_bold) VIS (ansi reset)"
  }
}

# ── Set Prompt ──
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| vi_indicator }
$env.PROMPT_INDICATOR_VI_INSERT = {|| vi_indicator }
$env.PROMPT_INDICATOR = {|| $"(ansi green)> (ansi reset)" }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi dark_gray)│ (ansi reset)" }
