# RAM segment for nushell prompt
# Shows memory usage percentage with bold formatting

export def ram_segment [] {
  try {
    let meminfo = (open /proc/meminfo | lines)
    let total_kb = ($meminfo | each { |line| $line | parse "MemTotal:{value} kB" } | first | get 0.value | str trim | into int)
    let avail_kb = ($meminfo | each { |line| $line | parse "MemAvailable:{value} kB" } | first | get 0.value | str trim | into int)
    let used_pct = ((($total_kb - $avail_kb) * 100) / $total_kb) | math round
    let icon = "󰍛"
    let color = if $used_pct >= 90 { "red_bold" } else if $used_pct >= 70 { "yellow" } else { "cyan" }
    $"(ansi $color)($icon)(ansi reset) (ansi white_bold)($used_pct)%(ansi reset)"
  } catch { "" }
}
