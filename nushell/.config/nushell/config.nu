# Monokai Pro Theme Definition
let monokai_pro = {
    red: "#fc618d"
    orange: "#fd9353"
    yellow: "#fce566"
    green: "#7bd88f"
    blue: "#5ad4e6"
    purple: "#948ae3"
    fg: "#f7f1ff"
    bg: "#222222"
    comment: "#69676c"
    selection: "#525053"
}

# Custom Practical Prompt Configuration (Nerd Fonts)
$env.PROMPT_COMMAND = {||
    # 0. Os Indicator
    let os_indicator = "\u{f31c}" # Ubuntu icon
    let os_segment = $"(ansi { fg: $monokai_pro.orange attr: b })($os_indicator) 26.04 "

    # 1. User Section
    let user_icon = "\u{f2bd}" # 
    let user_seg = $"(ansi { fg: $monokai_pro.red attr: b })($user_icon) ($env.USER)(ansi reset)"

    # 2. Directory Section
    let dir = (
        if ($env.PWD | path split | zip ($env.HOME | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $env.HOME "~")
        } else {
            $env.PWD
        }
    )
    let dir_icon = "\u{f07c}" # 
    let dir_seg = $"(ansi { fg: $monokai_pro.blue attr: b }) ($dir_icon) ($dir)(ansi reset)"

    # 3. Git Section
    let git_seg = if (".git" | path exists) or ((do { git rev-parse --is-inside-work-tree } | complete | get exit_code) == 0) {
        let branch = (do { git branch --show-current } | complete | get stdout | str trim)
        if ($branch | is-empty) { "" } else {
            let is_dirty = ((do { git status --porcelain } | complete | get stdout | str trim) != "")
            let g_color = if $is_dirty { $monokai_pro.yellow } else { $monokai_pro.green }
            let g_icon = "\u{e725}" # 
            let dirty_mark = if $is_dirty { "*" } else { "" }
            
            $"(ansi { fg: $g_color attr: b }) ($g_icon) ($branch)($dirty_mark)(ansi reset)"
        }
    } else {
        ""
    }

    # 4. Node Version (New)
    let node_seg = if ("package.json" | path exists) {
        let v = (do { node --version } | complete | get stdout | str trim)
        $"(ansi { fg: $monokai_pro.green attr: b }) 󰎙 ($v)(ansi reset)"
    } else { "" }

    # 5. Rust Version (New)
    let rust_seg = if ("Cargo.toml" | path exists) {
        let v = (do { rustc --version } | complete | get stdout | split row ' ' | get 1)
        $"(ansi { fg: $monokai_pro.orange attr: b }) 󱘗 ($v)(ansi reset)"
    } else { "" }

    # First line of the prompt
    $"($os_segment)($user_seg)($dir_seg)($git_seg)($node_seg)($rust_seg)\n"
}

$env.PROMPT_COMMAND_RIGHT = {||
    let exit_code = $env.LAST_EXIT_CODE
    let duration = ($env.CMD_DURATION_MS? | default 0 | into int)
    let time = (date now | format date "%H:%M:%S")
    
    let duration_seg = if $duration > 500 {
        let dur_str = ($duration | into duration --unit ms)
        $"(ansi { fg: $monokai_pro.purple })\u{f017} ($dur_str)(ansi reset) "
    } else {
        ""
    }
    
    let time_seg = $"(ansi { fg: $monokai_pro.comment }) ($time) (ansi reset)"

    let exit_seg = if $exit_code != 0 {
        $"(ansi { fg: $monokai_pro.red attr: b })\u{f00d} ($exit_code)(ansi reset)"
    } else {
        $"(ansi { fg: $monokai_pro.green attr: b })\u{f00c}(ansi reset)"
    }

    $"($duration_seg)($exit_seg)($time_seg)"
}

$env.PROMPT_INDICATOR = {|| $"(ansi { fg: $monokai_pro.green attr: b })❯(ansi reset) " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi { fg: $monokai_pro.green attr: b })❯(ansi reset) " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi { fg: $monokai_pro.orange attr: b })❮(ansi reset) " }
$env.PROMPT_MULTILINE_INDICATOR = {|| $" (ansi { fg: $monokai_pro.purple attr: b }):::(ansi reset) " }

# Carapace Config (Embedded)
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.PATH = ($env.PATH | split row (char esep) | where { $in != "/home/gence/.config/carapace/bin" } | prepend "/home/gence/.config/carapace/bin")

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
  load-env {
    CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
    CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
  }
  let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)
  let spans = (if $expanded_alias != null  {
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans | skip 1 | prepend ($spans.0)
  })
  carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  show_banner: false,
  completions: {
    external: {
      enable: true
      completer: $carapace_completer
    }
  },
  shell_integration: {
    osc133: false
  },
  render_right_prompt_on_last_line: true,
  
  ls: {
    use_ls_colors: true,
    clickable_links: true,
  },

  table: {
    mode: rounded,
    index_mode: always,
    show_empty: true,
    padding: { left: 1, right: 1 },
    trim: {
      methodology: wrapping,
      wrapping_try_keep_words: true,
      truncating_suffix: "...",
    },
  },

  keybindings: [
    {
      name: fzf_history
      modifier: control
      keycode: char_r
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline (history | each { |it| $it.command } | uniq | reverse | str join (char -i 0) | fzf --read0 --layout=reverse --height=40% -q (commandline) | decode utf-8 | str trim)"
      }
    }
    {
      name: fzf_file
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline (fzf --layout=reverse --height=40% --preview 'bat --style=numbers --color=always --line-range :500 {}' | decode utf-8 | str trim)"
      }
    }
    {
      name: repaint_prompt
      modifier: control
      keycode: char_r
      mode: [emacs vi_normal vi_insert]
      event: { send: Repaint }
    }
  ],

  color_config: {
    separator: $monokai_pro.fg
    leading_trailing_space_bg: { attr: n }
    header: { fg: $monokai_pro.green attr: b }
    empty: $monokai_pro.blue
    bool: $monokai_pro.purple
    int: $monokai_pro.purple
    filesize: $monokai_pro.purple
    duration: $monokai_pro.purple
    date: { fg: $monokai_pro.purple attr: b }
    range: $monokai_pro.purple
    float: $monokai_pro.purple
    string: $monokai_pro.yellow
    nothing: $monokai_pro.purple
    binary: $monokai_pro.purple
    cellpath: $monokai_pro.fg
    row_index: { fg: $monokai_pro.green attr: b }
    record: $monokai_pro.fg
    list: $monokai_pro.fg
    block: $monokai_pro.fg
    hints: $monokai_pro.comment
    search_result: { fg: $monokai_pro.red bg: $monokai_pro.fg }

    shape_external: { fg: $monokai_pro.red attr: b }
    shape_internalcall: { fg: $monokai_pro.orange attr: b }
    shape_string: $monokai_pro.yellow
    
    shape_and: { fg: $monokai_pro.purple attr: b }
    shape_binary: { fg: $monokai_pro.purple attr: b }
    shape_block: { fg: $monokai_pro.blue attr: b }
    shape_bool: $monokai_pro.purple
    shape_closure: { fg: $monokai_pro.green attr: b }
    shape_custom: $monokai_pro.green
    shape_datetime: { fg: $monokai_pro.blue attr: b }
    shape_directory: $monokai_pro.blue
    shape_externalarg: { fg: $monokai_pro.fg }
    shape_filepath: $monokai_pro.blue
    shape_flag: { fg: $monokai_pro.orange attr: i }
    shape_float: { fg: $monokai_pro.purple attr: b }
    shape_garbage: { fg: $monokai_pro.fg bg: $monokai_pro.red attr: b }
    shape_globpattern: { fg: $monokai_pro.blue attr: b }
    shape_int: { fg: $monokai_pro.purple attr: b }
    shape_keyword: { fg: $monokai_pro.purple attr: b }
    shape_list: { fg: $monokai_pro.blue attr: b }
    shape_literal: $monokai_pro.blue
    shape_match_pattern: $monokai_pro.green
    shape_matching_brackets: { attr: u }
    shape_nothing: $monokai_pro.purple
    shape_operator: $monokai_pro.purple
    shape_or: { fg: $monokai_pro.purple attr: b }
    shape_pipe: { fg: $monokai_pro.purple attr: b }
    shape_range: { fg: $monokai_pro.orange attr: b }
    shape_record: { fg: $monokai_pro.blue attr: b }
    shape_redirection: { fg: $monokai_pro.purple attr: b }
    shape_signature: { fg: $monokai_pro.green attr: b }
    shape_string_interpolation: { fg: $monokai_pro.blue attr: b }
    shape_table: { fg: $monokai_pro.blue attr: b }
    shape_variable: $monokai_pro.fg
    shape_vardecl: $monokai_pro.purple
  }
}

# Aliases from .bash_aliases

# ls aliases (using eza)
alias ls = ^eza --icons
alias ll = ^eza -l --icons --git -a
alias l = ^eza --icons --git
alias la = ^eza -a --icons --git
alias lt = ^eza --tree --level=2 --icons

# grep aliases (using external commands to preserve flags)
alias grep = ^grep --color=auto
alias fgrep = ^fgrep --color=auto
alias egrep = ^egrep --color=auto
alias zx = zellij --layout ide
source ~/.zoxide.nu





