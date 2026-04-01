# Git segment for nushell prompt
# Shows branch, ahead/behind, staged/unstaged/untracked counts with dynamic colors

export def git_segment [] {
  try {
    let git_root = (git rev-parse --show-toplevel o+e>| str trim)
    if ($git_root | is-empty) or ($git_root | str starts-with "fatal") {
      return ""
    }

    let branch = (git branch --show-current o+e>| str trim)
    let branch_display = if ($branch | is-empty) {
      let sha = (git rev-parse --short HEAD o+e>| str trim)
      if ($sha | is-empty) { return "" }
      $"(ansi dark_gray)detached@(ansi reset)(ansi cyan_bold)($sha)(ansi reset)"
    } else {
      $"(ansi white_bold)($branch)(ansi reset)"
    }

    let ahead_behind = (git rev-list --left-right --count HEAD...@{upstream} o+e>| str trim)
    let counts = if ($ahead_behind | is-empty) or ($ahead_behind | str contains "fatal") {
      [0, 0]
    } else {
      $ahead_behind | split row (char tab) | each { into int }
    }
    let ahead = $counts.0
    let behind = $counts.1

    let staged = (git diff --cached --name-only o+e>| lines | length)
    let unstaged = (git diff --name-only o+e>| lines | length)
    let untracked = (git ls-files --others --exclude-standard o+e>| lines | length)

    let indicators = [
      (if $staged > 0 { $"(ansi green)◆ ($staged)(ansi reset)" } else { "" }),
      (if $unstaged > 0 { $"(ansi yellow)● ($unstaged)(ansi reset)" } else { "" }),
      (if $untracked > 0 { $"(ansi blue)◇ ($untracked)(ansi reset)" } else { "" }),
      (if $ahead > 0 { $"(ansi cyan)↑ ($ahead)(ansi reset)" } else { "" }),
      (if $behind > 0 { $"(ansi red)↓ ($behind)(ansi reset)" } else { "" }),
    ] | where ($it | str length) > 0 | str join " "

    let has_conflicts = (git diff --name-only --diff-filter=U o+e>| lines | length) > 0
    let color = if $has_conflicts { "red_bold" } else if $staged > 0 and $unstaged > 0 { "yellow_bold" } else if $staged > 0 { "green_bold" } else if $unstaged > 0 { "yellow_bold" } else { "green" }

    let status = if ($indicators | str length) > 0 { $" (ansi dark_gray)│(ansi reset) ($indicators)" } else { "" }

    $" (ansi $color) (ansi reset)($branch_display)($status)"
  } catch { "" }
}
