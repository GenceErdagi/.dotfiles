# Git segment for nushell prompt
# Shows branch, ahead/behind, staged/unstaged/untracked counts with dynamic colors
# Cached for 5 seconds to avoid expensive git calls on every prompt

const GIT_CACHE_TTL = 5
const GIT_CACHE_FILE = ($nu.cache-dir | path join "git_segment_cache.json")

def load_git_cache [] {
  try {
    let cached = (open $GIT_CACHE_FILE | from json)
    let age = (date now | format date "%s" | into int) - $cached.timestamp
    if $age < $GIT_CACHE_TTL { $cached.data } else { "" }
  } catch { "" }
}

def save_git_cache [data: string] {
  let cache = { timestamp: (date now | format date "%s" | into int), data: $data }
  $cache | to json | save -f $GIT_CACHE_FILE
}

export def git_segment [] {
  let cached = (load_git_cache)
  if ($cached != "") { return $cached }

  let git_root = (try { git rev-parse --show-toplevel o+e>| str trim } catch { "" })
  if ($git_root == "") { return "" }

  let branch = (try { git branch --show-current o+e>| str trim } catch { "" })
  let branch_display = if ($branch == "") {
    let sha = (try { git rev-parse --short HEAD o+e>| str trim } catch { "" })
    if ($sha == "") { return "" }
    $"(ansi dark_gray)detached@(ansi reset)(ansi cyan_bold)($sha)(ansi reset)"
  } else {
    $"(ansi white_bold)($branch)(ansi reset)"
  }

  let ahead_behind = (try { git rev-list --left-right --count HEAD...@{upstream} o+e>| str trim } catch { "" })
  let counts = if ($ahead_behind == "") { [0, 0] } else { $ahead_behind | split row (char tab) | each { into int } }
  let ahead = $counts.0
  let behind = $counts.1

  let staged = (try { git diff --cached --name-only o+e>| lines | length } catch { "0" } | into int)
  let unstaged = (try { git diff --name-only o+e>| lines | length } catch { "0" } | into int)
  let untracked = (try { git ls-files --others --exclude-standard o+e>| lines | length } catch { "0" } | into int)

  let indicators = [
    (if $staged > 0 { $"(ansi green)◆ ($staged)(ansi reset)" } else { "" }),
    (if $unstaged > 0 { $"(ansi yellow)● ($unstaged)(ansi reset)" } else { "" }),
    (if $untracked > 0 { $"(ansi blue)◇ ($untracked)(ansi reset)" } else { "" }),
    (if $ahead > 0 { $"(ansi cyan)↑ ($ahead)(ansi reset)" } else { "" }),
    (if $behind > 0 { $"(ansi red)↓ ($behind)(ansi reset)" } else { "" }),
  ] | where ($it | str length) > 0 | str join " "

  let has_conflicts = (try { git diff --name-only --diff-filter=U o+e>| lines | length } catch { "0" } | into int) > 0
  let color = if $has_conflicts { "red_bold" } else if $staged > 0 and $unstaged > 0 { "yellow_bold" } else if $staged > 0 { "green_bold" } else if $unstaged > 0 { "yellow_bold" } else { "green" }

  let status = if ($indicators | str length) > 0 { $" (ansi dark_gray)│(ansi reset) ($indicators)" } else { "" }

  let result = $" (ansi $color) (ansi reset)($branch_display)($status)"
  save_git_cache $result
  $result
}
