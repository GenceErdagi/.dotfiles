let zoxide_completer = {|spans|
  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
  match $spans.0 {
    z | zi | __zoxide_z | __zoxide_zi | cd | cdi => $zoxide_completer
    _ => {|| [] }
  } | do $in $spans
}

$env.config.completions.external = {
  max_results: 20
  enable: true
  completer: $external_completer
}
