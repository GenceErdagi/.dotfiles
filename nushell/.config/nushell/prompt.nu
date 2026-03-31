# Nushell prompt with Nerd Fonts, vi mode (matching Helix cursors)
# Normal = ▮ (green), Insert = │ (cyan)

def create_left_prompt [] {
  let dir = ($env.PWD | str replace $env.HOME "~")

  let git = try {
    let branch = (git branch --show-current | str trim)
    let dirty = not (git status --porcelain | is-empty)
    let icon = if $dirty { "" } else { "" }
    let color = if $dirty { "yellow" } else { "green" }
    $" (ansi $color)($icon) ($branch)(ansi reset)"
  } catch { "" }

  let time = (date now | format date "%H:%M")

  $"(ansi blue) ($dir)(ansi reset)($git)  (ansi dark_gray)($time)(ansi reset)"
}

def create_right_prompt [] {
  ""
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
