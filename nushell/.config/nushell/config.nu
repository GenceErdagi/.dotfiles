$env.config.show_banner = false

const config_dir = ($nu.config-path | path dirname)

$env.config.plugins = { gstat: {} }

source ($config_dir | path join "prompt.nu")
source ($config_dir | path join "zellij.nu")
source ($config_dir | path join "yazi.nu")
source ($config_dir | path join "completions.nu")
source ($config_dir | path join "aliases.nu")

source ~/.zoxide.nu

# Enable vi mode
$env.config.edit_mode = "vi"

# Cursor shapes matching Helix (line for insert, block for normal)
$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}

# ──────────────────────────────────────────────────────────────
# Helix-inspired keybindings (vi-normal mode)
# ──────────────────────────────────────────────────────────────
$env.config.keybindings = ($env.config.keybindings | append [
  {
    name: helix_delete_selection
    modifier: none
    keycode: char_d
    mode: vi_normal
    event: { edit: Delete }
  }
  {
    name: helix_cut_selection
    modifier: shift
    keycode: char_d
    mode: vi_normal
    event: { edit: CutSelection }
  }
  {
    name: helix_select_all
    modifier: none
    keycode: char_x
    mode: vi_normal
    event: { edit: SelectAll }
  }
  {
    name: helix_extend_to_next_word
    modifier: none
    keycode: char_w
    mode: vi_normal
    event: { edit: MoveWordRight select: true }
  }
  {
    name: helix_extend_to_word_end
    modifier: none
    keycode: char_e
    mode: vi_normal
    event: { edit: MoveWordRightEnd select: true }
  }
  {
    name: helix_extend_to_prev_word
    modifier: none
    keycode: char_b
    mode: vi_normal
    event: { edit: MoveWordLeft select: true }
  }
  {
    name: helix_yank_selection
    modifier: none
    keycode: char_y
    mode: vi_normal
    event: { edit: CopySelection }
  }
  {
    name: helix_paste_after
    modifier: none
    keycode: char_p
    mode: vi_normal
    event: { edit: PasteCutBufferAfter }
  }
  {
    name: helix_paste_before
    modifier: shift
    keycode: char_p
    mode: vi_normal
    event: { edit: PasteCutBufferBefore }
  }
  {
    name: helix_undo
    modifier: none
    keycode: char_u
    mode: vi_normal
    event: { edit: Undo }
  }
  {
    name: helix_redo
    modifier: shift
    keycode: char_u
    mode: vi_normal
    event: { edit: Redo }
  }
  {
    name: helix_change_selection
    modifier: none
    keycode: char_c
    mode: vi_normal
    event: [
      { edit: Delete }
      { send: vichangemode mode: insert }
    ]
  }
  {
    name: helix_history_hint_word_complete_vi_normal
    modifier: control
    keycode: char_e
    mode: vi_normal
    event: [
      { send: HistoryHintWordComplete }
      { send: MenuRight }
      { send: Right }
    ]
  }
  {
    name: helix_history_hint_word_complete_vi_insert
    modifier: control
    keycode: char_e
    mode: vi_insert
    event: [
      { send: HistoryHintWordComplete }
      { send: MenuRight }
      { send: Right }
    ]
  }
  {
    name: helix_history_hint_complete_vi_normal
    modifier: control
    keycode: char_l
    mode: vi_normal
    event: [
      { send: HistoryHintComplete }
      { send: MenuRight }
      { send: Right }
    ]
  }
  {
    name: helix_history_hint_complete_vi_insert
    modifier: control
    keycode: char_l
    mode: vi_insert
    event: [
      { send: HistoryHintComplete }
      { send: MenuRight }
      { send: Right }
    ]
  }
])
