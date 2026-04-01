# Battery segment for nushell prompt
# Shows battery percentage with dynamic icons and bold formatting

export def battery_segment [] {
  try {
    let bat_path = (ls /sys/class/power_supply/BAT* | first | get name)
    let capacity = (open ($bat_path | path join "capacity") | str trim | into int)
    let status_raw = (open ($bat_path | path join "status") | str trim | str downcase)
    let charging = ($status_raw | str contains "charg")
    let full = ($status_raw | str contains "full")

    let icon = if $full { "󰁹" } else if $charging { "󰂄" } else {
      if $capacity >= 95 { "󰁹" } else if $capacity >= 80 { "󰂂" } else if $capacity >= 60 { "󰂁" } else if $capacity >= 40 { "󰂀" } else if $capacity >= 20 { "󰁿" } else { "󰁺" }
    }

    let color = if $full { "green_bold" } else if $charging { "green_bold" } else if $capacity >= 60 { "cyan" } else if $capacity >= 20 { "yellow" } else { "red_bold" }

    $"(ansi $color)($icon)(ansi reset) (ansi white_bold)($capacity)%(ansi reset)"
  } catch { "" }
}
