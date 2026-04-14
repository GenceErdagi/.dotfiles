let zoxide_completer = {|spans|
  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let fish_completer = {|spans|
  let cmd = $spans | str replace --all '"' '\\"' | str join ' '
  let result = (fish --command $"complete '--do-complete=($cmd)'" 
    | lines 
    | parse --regex "(?P<value>\\S+)\\t(?P<description>.*)")
  if ($result | is-empty) { null } else {
    $result | each {|row|
      let val = $row.value
      let need_quote = ([\\, ',', '[', ']', '(', ')', ' ', '\t', "'", '"', '`'] | any {$in in $val})
      let fixed_val = if ($val | str starts-with "~") {
        let expanded = ($val | path expand)
        if $need_quote { $"\"($expanded | str replace --all '\"' '\\\\\"')\"" } else { $expanded }
      } else if $need_quote { $"\"($val | str replace --all '\"' '\\\\\"')\"" } else { $val }
      $row | upsert value $fixed_val
    }
  }
}

let external_completer = {|spans|
  match $spans.0 {
    z | zi | __zoxide_z | __zoxide_zi | cd | cdi => { $zoxide_completer | do $in $spans }
    _ => { $fish_completer | do $in $spans }
  }
}

let history_completer = {|spans|
  if ($spans.0 | str length) < 2 {
    []
  } else {
    let results = (^atuin search 
      --cwd $env.PWD 
      --limit 15 
      --fuzzy-count 15
      --cmd-only 
      ($spans | str join ' ')
      | lines)
    if ($results | is-empty) { [] } else {
      $results | each {|cmd| {value: $cmd, description: "history"} }
    }
  }
}

mut completions_config = ($env.config.completions | default {})
$completions_config = ($completions_config | upsert algorithm "fuzzy")
$completions_config = ($completions_config | upsert external {
  max_results: 30
  enable: true
  completer: $external_completer
})
$completions_config = ($completions_config | upsert case_sensitive false)
$completions_config = ($completions_config | upsert quick true)
$env.config.completions = $completions_config

$env.config.history = {
  max_size: 100000
  sync_on_enter: true
  file_format: plaintext
  isolation: false
  ignore_space_prefixed: true
  path: ($nu.data-dir | path join "history.txt")
}