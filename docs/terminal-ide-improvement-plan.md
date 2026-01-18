# Terminal IDE Improvement Plan

## Overview

Plan to enhance the Zellij + Helix + Yazi terminal IDE environment using Nushell as the communication layer and community plugins.

---

## Phase 1: Core Integration Infrastructure

### 1.1 Nushell Communication Layer

**Files to Create:**
- `~/.config/nushell/helix-socket.nu` - Socket-based Helix communication
- `~/.config/nushell/open_in_hx.nu` - Enhanced file opening (replaces `open_in_hx.sh`)
- `~/.config/nushell/terminal-helpers.nu` - Terminal error parsing
- `~/.config/nushell/workspace.nu` - Session/workspace persistence

**Purpose:**
- Reliable file opening without sleep+keystrokes
- Bidirectional navigation between components
- Terminal error parsing for quick file navigation
- Workspace save/restore functionality

---

## Phase 2: Yazi Enhancement

### 2.1 Core Yazi Plugins

#### Git Integration
- **[yazi-rs/git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi)** - Show git status as linemode
  ```bash
  ya pkg add yazi-rs/plugins:git
  ```

- **[yazi-rs/vcs-files.yazi](https://github.com/yazi-rs/plugins/tree/main/vcs-files.yazi)** - Show git file changes
  ```bash
  ya pkg add yazi-rs/plugins:vcs-files
  ```

- **[llanosrocas/githead.yazi](https://github.com/llanosrocas/githead)** - Git status header inspired by powerlevel10k
  ```bash
  ya pkg add llanosrocas/githead
  ```

- **[Lil-Dank/lazygit.yazi](https://github.com/Lil-Dank/lazygit)** - Quick lazygit integration
  ```bash
  ya pkg add Lil-Dank/lazygit
  ```

#### Navigation & Search
- **[stelcodes/bunny.yazi](https://github.com/stelcodes/bunny)** - Bookmarks with fuzzy search
  ```bash
  ya pkg add stelcodes/bunny
  ```

- **[lpnh/fr.yazi](https://gitee.com/lpnh/fr.yazi)** - fzf + ripgrep integration
  ```bash
  ya pkg add lpnh/fr
  ```

- **[Mr-Ples/command-palette.yazi](https://github.com/Mr-Ples/command-palette)** - Fuzzy keybind search
  ```bash
  ya pkg add Mr-Ples/command-palette
  ```

- **[dedukun/bookmarks.yazi](https://github.com/dedukun/bookmarks)** - Vi-like marks
  ```bash
  ya pkg add dedukun/bookmarks
  ```

- **[whoosh.yazi](https://github.com/WhoSowSee/whoosh)** - Advanced bookmark manager with persistent/temporary bookmarks
  ```bash
  ya pkg add WhoSowSee/whoosh
  ```

#### File Operations
- **[yazi-rs/diff.yazi](https://github.com/yazi-rs/plugins/tree/main/diff.yazi)** - Diff selected files
  ```bash
  ya pkg add yazi-rs/plugins:diff
  ```

- **[yazi-rs/chmod.yazi](https://github.com/yazi-rs/plugins/tree/main/chmod.yazi)** - Change file modes
  ```bash
  ya pkg add yazi-rs/plugins:chmod
  ```

- **[uhs-robert/recycle-bin.yazi](https://github.com/uhs-robert/recycle-bin.yazi)** - Trash management
  ```bash
  ya pkg add uhs-robert/recycle-bin.yazi
  ```

- **[boydaihungst/restore.yazi](https://github.com/boydaihungst/restore)** - Undo/Recover trashed files
  ```bash
  ya pkg add boydaihungst/restore
  ```

#### UI Enhancements
- **[llanosrocas/yaziline.yazi](https://github.com/llanosrocas/yaziline)** - Custom status line
  ```bash
  ya pkg add llanosrocas/yaziline
  ```

- **[yazi-rs/full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi)** - Add full border
  ```bash
  ya pkg add yazi-rs/plugins:full-border
  ```

- **[Ape/simple-status.yazi](https://github.com/Ape/simple-status)** - Minimalistic status line
  ```bash
  ya pkg add Ape/simple-status
  ```

#### Clipboard
- **[simla33/ucp.yazi](https://github.com/simla33/ucp)** - Cross-platform copy-paste
  ```bash
  ya pkg add simla33/ucp
  ```

- **[orhnk/system-clipboard.yazi](https://github.com/orhnk/system-clipboard)** - System clipboard support
  ```bash
  ya pkg add orhnk/system-clipboard
  ```

### 2.2 Yazi Configuration Updates

**Keymap additions:**
- `g` - Open bookmark (bunny)
- `;` - Quick open in Helix via Nushell
- `<C-g>` - Open lazygit
- `<Space>` - Toggle preview (enhance current toggle-pane)

---

## Phase 3: Zellij Enhancement

### 3.1 Core Zellij Plugins

#### Navigation
- **[harpoon](https://github.com/Nacho114/harpoon)** - Quick pane navigation (nvim harpoon clone)
  ```bash
  zellij --setup harpoon
  ```

- **[zellij-pane-picker](https://github.com/shihanng/zellij-pane-picker)** - Switch between panes with stars
  ```bash
  zellij --setup zellij-pane-picker
  ```

- **[zjpane](https://github.com/FuriouZz/zjpane)** - Navigate between panes easily
  ```bash
  zellij --setup zjpane
  ```

#### Session Management
- **[zellij-sessionizer](https://github.com/laperlej/zellij-sessionizer)** - Fuzzy project switching
  ```bash
  zellij --setup zellij-sessionizer
  ```

- **[zellij-favs](https://github.com/JoseMM2002/zellij-favs)** - Save favorite sessions
  ```bash
  zellij --setup zellij-favs
  ```

- **[zellij-choose-tree](https://github.com/laperlej/zellij-choose-tree)** - Switch sessions like tmux
  ```bash
  zellij --setup zellij-choose-tree
  ```

- **[zsm](https://github.com/liam-mackie/zsm)** - Zoxide-integrated session switcher
  ```bash
  zellij --setup zsm
  ```

#### Git
- **[zj-git-branch](https://github.com/dam4rus/zj-git-branch)** - Branch management
  ```bash
  zellij --setup zj-git-branch
  ```

#### System Monitoring
- **[zellij-load](https://github.com/Christian-Prather/zellij-load)** - CPU/memory usage
  ```bash
  zellij --setup zellij-load
  ```

#### Command Management
- **[zellij-playbooks](https://github.com/yaroslavborbat/zellij-playbooks)** - Execute commands from playbooks
  ```bash
  zellij --setup zellij-playbooks
  ```

- **[zellij-bookmarks](https://github.com/yaroslavborbat/zellij-bookmarks)** - Command bookmarks
  ```bash
  zellij --setup zellij-bookmarks
  ```

#### Utilities
- **[zellij-forgot](https://github.com/karimould/zellij-forgot)** - Show keybinds
  ```bash
  zellij --setup zellij-forgot
  ```

- **[zellij-datetime](https://github.com/h1romas4/zellij-datetime)** - Date/time pane
  ```bash
  zellij --setup zellij-datetime
  ```

- **[zellij-what-time](https://github.com/pirafrank/zellij-what-time)** - Time in status bar
  ```bash
  zellij --setup zellij-what-time
  ```

### 3.2 Zellij Status Bar Enhancement

**Update `zjstatus` configuration:**
- Add git branch from `zj-git-branch`
- Add CPU/memory from `zellij-load`
- Add diagnostics count from Helix

---

## Phase 4: Layout Enhancement

### 4.1 Enhanced IDE Layout

**New pane structure:**
```
┌─────────────┬────────────────────┬──────────────┐
│             │                    │              │
│   Yazi      │      Helix         │   Problems   │
│  (15%)      │     (60%)          │   (25%)      │
│             │                    │              │
├─────────────┴────────────────────┼──────────────┤
│                                       Terminal   │
│                                       (25%)      │
└──────────────────────────────────────────────────┘
```

**New pane: Problems**
- Shows compiler errors from terminal
- Parseable with fzf
- Click to open file:line in Helix

### 4.2 Layout Variants

- **Debug Layout** - With problems pane expanded
- **Minimal Layout** - Just Yazi + Helix
- **Full Layout** - With git/lazygit pane

---

## Phase 5: Keybinding Integration

### 5.1 Zellij Keybindings

**Add to `config.kdl`:**
```kdl
bind "Alt o" { LaunchOrFocusPlugin "zellij-pane-picker" { floating true } }
bind "Alt s" { LaunchOrFocusPlugin "harpoon" { floating true } }
bind "Alt g" { LaunchOrFocusPlugin "zj-git-branch" { floating true } }
bind "Alt e" { RunCommand "nu" { args "-c" "nu ~/.config/nushell/parse-compiler-errors.nu" floating true } }
bind "Alt w" { LaunchOrFocusPlugin "zellij-sessionizer" { floating true } }
bind "Alt b" { LaunchOrFocusPlugin "zellij-favs" { floating true } }
bind "Alt f" { LaunchOrFocusPlugin "zellij-forgot" { floating true } }
bind "Alt p" { LaunchOrFocusPlugin "zellij-playbooks" { floating true } }
```

### 5.2 Yazi Keybindings

**Add to `keymap.toml`:**
```toml
[[manager.prepend_keymap]]
on = ["g"]
run = "plugin --sync bunny"
desc = "Go to bookmark"

[[manager.prepend_keymap]]
on = ["<C-g>"]
run = "shell 'git lazygit'"
desc = "Open lazygit"

[[manager.prepend_keymap]]
on = ["<C-o>"]
run = "shell --confirm 'nu ~/.config/nushell/open_in_hx.nu $FX'"
desc = "Quick open in Helix"
```

### 5.3 Helix Keybindings

**Add to `config.toml`:**
```toml
[keys.normal]
C-o = ":sh nu ~/.config/nushell/get-helix-file.nu"
C-g = ":sh zellij action move-focus left"
```

---

## Phase 6: Advanced Features

### 6.1 Workspace Persistence

**Features:**
- Save/restore open files
- Save/restore Yazi path
- Save/restore git branch
- Save/restore terminal history

### 6.2 Bidirectional Navigation

**Features:**
- Helix → Yazi: Highlight current file
- Yazi → Helix: Open selected file
- Terminal → Helix: Open file:line from errors

### 6.3 Project Search

**Implementation:**
- Use Yazi's `fr` plugin (fzf + ripgrep)
- Parse results for quick navigation
- Show results in dedicated pane

### 6.4 Diagnostics Integration

**Features:**
- Show error count in Zellij status bar
- Parse Helix diagnostics
- Show warnings/errors in Problems pane
- Quick fix suggestions

---

## Implementation Order

### Priority 1 (Core)
1. Nushell socket communication
2. Replace `open_in_hx.sh` with Nushell version
3. Add essential Yazi plugins (git, bookmarks)
4. Update Yazi keybindings

### Priority 2 (Integration)
1. Add Zellij navigation plugins (harpoon, pane-picker)
2. Add session management plugins
3. Update Zellij keybindings
4. Add problems pane to layout

### Priority 3 (Enhancement)
1. Add UI plugins (status lines, borders)
2. Add system monitoring
3. Add git branch management
4. Add workspace persistence

### Priority 4 (Polish)
1. Add clipboard support
2. Add file operation plugins
3. Add command palette
4. Add playbooks

---

## Plugin Summary by Category

### Git (Yazi)
- [yazi-rs/git.yazi](https://github.com/yazi-rs/plugins/tree/main/git.yazi)
- [yazi-rs/vcs-files.yazi](https://github.com/yazi-rs/plugins/tree/main/vcs-files.yazi)
- [llanosrocas/githead.yazi](https://github.com/llanosrocas/githead)
- [Lil-Dank/lazygit.yazi](https://github.com/Lil-Dank/lazygit)

### Navigation (Yazi)
- [stelcodes/bunny.yazi](https://github.com/stelcodes/bunny)
- [lpnh/fr.yazi](https://gitee.com/lpnh/fr.yazi)
- [Mr-Ples/command-palette.yazi](https://github.com/Mr-Ples/command-palette)
- [dedukun/bookmarks.yazi](https://github.com/dedukun/bookmarks)
- [whoosh.yazi](https://github.com/WhoSowSee/whoosh)

### File Operations (Yazi)
- [yazi-rs/diff.yazi](https://github.com/yazi-rs/plugins/tree/main/diff.yazi)
- [yazi-rs/chmod.yazi](https://github.com/yazi-rs/plugins/tree/main/chmod.yazi)
- [uhs-robert/recycle-bin.yazi](https://github.com/uhs-robert/recycle-bin.yazi)
- [boydaihungst/restore.yazi](https://github.com/boydaihungst/restore)

### UI (Yazi)
- [llanosrocas/yaziline.yazi](https://github.com/llanosrocas/yaziline)
- [yazi-rs/full-border.yazi](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi)
- [Ape/simple-status.yazi](https://github.com/Ape/simple-status)

### Clipboard (Yazi)
- [simla33/ucp.yazi](https://github.com/simla33/ucp)
- [orhnk/system-clipboard.yazi](https://github.com/orhnk/system-clipboard)

### Navigation (Zellij)
- [harpoon](https://github.com/Nacho114/harpoon)
- [zellij-pane-picker](https://github.com/shihanng/zellij-pane-picker)
- [zjpane](https://github.com/FuriouZz/zjpane)

### Session Management (Zellij)
- [zellij-sessionizer](https://github.com/laperlej/zellij-sessionizer)
- [zellij-favs](https://github.com/JoseMM2002/zellij-favs)
- [zellij-choose-tree](https://github.com/laperlej/zellij-choose-tree)
- [zsm](https://github.com/liam-mackie/zsm)

### Git (Zellij)
- [zj-git-branch](https://github.com/dam4rus/zj-git-branch)

### System (Zellij)
- [zellij-load](https://github.com/Christian-Prather/zellij-load)
- [zellij-datetime](https://github.com/h1romas4/zellij-datetime)
- [zellij-what-time](https://github.com/pirafrank/zellij-what-time)

### Command Management (Zellij)
- [zellij-playbooks](https://github.com/yaroslavborbat/zellij-playbooks)
- [zellij-bookmarks](https://github.com/yaroslavborbat/zellij-bookmarks)

### Utilities (Zellij)
- [zellij-forgot](https://github.com/karimould/zellij-forgot)

---

## Testing Checklist

- [ ] Nushell socket communication works
- [ ] File opening from Yazi to Helix works
- [ ] Error parsing from terminal works
- [ ] Bookmark navigation works
- [ ] Pane switching works
- [ ] Session save/restore works
- [ ] Git integration works
- [ ] Problems pane shows errors
- [ ] All keybindings work
- [ ] Status bar shows correct info

---

## Notes

### Current Configuration to Keep
- `zjstatus` - Keep and enhance
- `toggle-pane.yazi` - Keep and integrate
- `workspace-guard.yazi` - Keep
- `smart-enter.yazi` - Keep
- `no-status.yazi` - Keep (may replace with yaziline)

### Configuration to Replace
- `open_in_hx.sh` - Replace with Nushell version
- Current `ide.kdl` - Enhance with problems pane
- Current keybindings - Add new ones

### Potential Issues
- Some Zellij plugins may need Rust/WASM compilation
- Socket-based communication may need permissions setup
- Yazi plugins may need Lua dependencies
- Nushell version compatibility

---

## Related Projects for Reference

- [theylix](https://codeberg.org/hobgoblina/theylix) - Zellij + Helix + tools integration
- [yazelix](https://github.com/luccahuguet/yazelix) - Zellij + Yazi + Nushell + Helix
- [zide](https://github.com/josephschmitt/zide) - Zellij IDE layouts
- [zellix](https://github.com/TheEmeraldBee/zellix) - Nushell wrapper for Helix
