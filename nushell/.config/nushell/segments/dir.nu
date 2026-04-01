# Directory segment for nushell prompt
# Shows current directory with bold formatting

export def dir_segment [] {
  let dir = ($env.PWD | str replace $env.HOME "~")
  $"(ansi blue_bold) (ansi reset)(ansi blue)($dir)(ansi reset)"
}
