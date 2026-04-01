# Time segment for nushell prompt
# Shows date and time with bold formatting and separator

export def time_segment [] {
  let now = (date now)
  let date_part = ($now | format date "%d/%m")
  let time_part = ($now | format date "%H:%M")
  $"(ansi magenta)(ansi reset) (ansi white_bold)($date_part)(ansi reset) (ansi dark_gray)│(ansi reset) (ansi yellow)(ansi reset) (ansi white_bold)($time_part)(ansi reset)"
}
