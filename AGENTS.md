# AGENTS.md

This document provides guidance for agentic coding assistants working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. It contains configuration files for various tools including Helix editor, Yazi file manager, Zellij terminal multiplexer, and Nushell shell.

### Installation Commands

```bash
# Install all configurations
cd ~/dotfiles
stow helix yazi yazi-zx zellij nushell home -t ~

# Install individual package
stow helix -t ~

# Unstow (remove symlinks)
stow -D helix -t ~
```

## Code Style Guidelines

### Lua (Yazi Plugins)

- **Structure**: Yazi plugins follow specific patterns with exported functions
- **Common exports**: `setup()`, `fetch()`, `entry()` functions
- **Naming**: Use lowercase with underscores for functions (`bubble_up`, `match`)
- **Type hints**: Use `---@param` and `---@return` annotations where applicable
- **Code style**: 4-space indentation, no trailing whitespace
- **Comments**: Use `---` for documentation comments with `@since` dates
- **Error handling**: Return errors using `Err()` for fetch operations
- **UI operations**: Use `ya.sync()` for state synchronization and `ui.render()` for updates

Example pattern:
```lua
local function setup(self, opts)
  self.open_multi = opts.open_multi
end

local function entry(self)
  local h = cx.active.current.hovered
  ya.emit(h and h.cha.is_dir and "enter" or "open")
end

return { entry = entry, setup = setup }
```

### TOML (Configuration Files)

- **Structure**: Standard TOML format with nested sections
- **Arrays**: Use `[[section]]` for arrays of tables (e.g., `[[language]]`, `[[plugin.deps]]`)
- **Strings**: Quote all string values
- **Booleans**: Use lowercase `true`/`false`
- **Comments**: Use `#` for comments, align where sensible
- **Indentation**: 4-space indentation for nested structures

### Bash Scripts

- **Shebang**: Use `#!/usr/bin/env bash` for portability
- **Logging**: Include log statements for debugging (write to `/tmp/*.log`)
- **Variable naming**: UPPERCASE for environment/constants, lowercase for local variables
- **Command substitution**: Use `$()` syntax instead of backticks
- **Error handling**: Redirect stderr to log files with `>> "$LOG_FILE" 2>&1`
- **Path resolution**: Use `readlink -f` for absolute paths
- **Quotes**: Quote all variable expansions: `"$VAR"`

Example pattern:
```bash
#!/usr/bin/env bash

LOG_FILE="/tmp/debug.log"
FILE_PATH=$(readlink -f "$1")
echo "Argument: $1" >> "$LOG_FILE"

for FILE in "$@"; do
  FILE_PATH=$(readlink -f "$FILE")
  command "$FILE_PATH"
done
```

### Nushell Scripts

- **Variables**: Use `$env.PREFIX` for environment variables, `$name` for regular variables
- **Functions**: Use `def` for regular functions, `def --env` for environment-affecting functions
- **Command execution**: Use `^command` for external commands to avoid Nushell builtins
- **Strings**: Use double quotes for interpolation `"$var"`, single quotes for literals
- **Pipelines**: Use `|` for chaining commands
- **Conditionals**: Use `if ... { } else { }` blocks
- **Colors**: Define color themes as record with named fields

Example pattern:
```nu
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  ^yazi ...$args --cwd-file $tmp
  rm -f $tmp
}
```

## Language-Specific Guidelines

### Helix Editor (config.toml, languages.toml)

- **Theme**: Use "monokai_spectrum_custom" as the theme
- **Line numbers**: Use "relative" line numbering
- **Indentation**: 4 spaces for TOML configuration
- **Auto-pairs**: Configure matching pairs for common delimiters
- **Language servers**: Use appropriate LSP for each language (ts-language-server for TS/JS, etc.)

### Yazi File Manager

- **Plugins**: Organize under `yazi/.config/yazi/plugins/PLUGIN_NAME.yazi/`
- **Keymaps**: Define in `keymap.toml` with `[[mgr.prepend_keymap]]` format
- **Fetchers**: Use `[[plugin.prepend_fetchers]]` for custom file fetchers
- **Theme**: Define custom themes in `flavors/` directory

## Custom Workflows

### ZX Terminal IDE Workflow

The **ZX workflow** is a custom terminal IDE environment that integrates Zellij, Yazi, Helix, and Nushell into a seamless development experience. This workflow provides an IDE-like interface entirely within the terminal.

#### Entry Point

Run `zx` in Nushell to launch the terminal IDE:
```bash
zx  # Alias for: zellij --layout ide
```

This launches Zellij with the `ide` layout (see `zellij/.config/zellij/layouts/ide.kdl`).

#### Component Architecture

**Zellij (`zellij/.config/zellij/`)**
- **IDE Layout**: 3-pane vertical split (Yazi, Helix, Terminal)
- **Keybindings**: Custom keybindings in `config.kdl` with zjstatus plugin
- **Swap Layouts**: `ide.swap.kdl` provides layout variants (no_sidebar, no_terminal, zen)
- **Environment**: Sets `YAZI_IDE_SIDEBAR=1` for Yazi integration mode

**Yazi-ZX (`yazi-zx/.config/yazi-zx/`)**
- **Configuration**: Separate Yazi config directory for IDE mode
- **Environment Variables**:
  - `YAZI_ZX_ROOT`: Tracks initial working directory (workspace root)
  - `YAZI_IDE_SIDEBAR=1`: Indicates sidebar mode
- **Persistence**: Maintains state between file selections via `/tmp/yazi_selection` and `/tmp/yazi_cwd`

**yazi-zx Wrapper Script (`nushell/.config/nushell/yazi-zx.nu`)**
- **Purpose**: Runs Yazi in persistent loop for IDE mode
- **Workflow**:
  1. Sets `YAZI_CONFIG_HOME=~/.config/yazi-zx`
  2. Records initial path as `YAZI_ZX_ROOT`
  3. Runs Yazi with `--chooser-file` and `--cwd-file`
  4. On file selection: opens files in Helix and reopens Yazi at new location
  5. Loop continues until no file selected (exit Yazi)
  6. Cleans up temp files

**Yazi-ZX Plugins**

1. **smart-enter**: Intelligently enters directories or opens files
   - Keybinds: `Enter`, `l`
   - Behavior: Enter directory if hovered item is directory, otherwise open file

2. **workspace-guard**: Prevents navigating beyond workspace root
   - Keybinds: `h`, `Left`
   - Behavior: Blocks navigation beyond `YAZI_ZX_ROOT`
   - Shows notification when at workspace root

3. **toggle-pane**: Minimize/maximize Yazi panes
   - Usage: Toggle preview pane visibility or maximize panes
   - Modifies Yazi layout ratios dynamically

4. **confirm-quit**: Prevents accidental Yazi exit
   - Keybind: `q` (shows notification)
   - Keybind: `Q` (quits immediately)
   - Behavior: Shows notification "Press 'q' again to quit"

5. **no-status**: Hides Yazi's default status bar
   - Purpose: Clean sidebar appearance

6. **git**: Shows git status in file listings
   - Displays modified, added, deleted, untracked files
   - Color-coded indicators in linemode

**File Opening Mechanism**

Script: `yazi-zx/scripts/open_in_hx.sh`

Process:
1. Receives selected file paths as arguments
2. Moves focus from Yazi (left) to Helix (right pane)
3. Ensures focus is in Helix (top-right), not Terminal (bottom-right)
4. For each file:
   - Resolves absolute path with `readlink -f`
   - Sends ESC key (code 27) to Helix via Zellij
   - Sends `:open <filepath>` command
   - Sends Enter key (code 13)
   - 0.1s delay between files

Key mappings:
- `Enter`/`l` in Yazi → Opens file via Helix
- File paths resolved to absolute paths
- Multiple files supported (opens in Helix tabs)

**Zellij Integration**

- **pane focus navigation**: `zellij action move-focus` switches between panes
- **keystroke simulation**: `zellij action write` and `write-chars` control Helix
- **layout management**: Swap layouts available via `Alt+[` and `Alt+]`

#### Configuration Files

**Zellij Layout (`zellij/.config/zellij/layouts/ide.kdl`)**
```kdl
tab focus=true {
    pane split_direction="vertical" {
        pane size="15%" command="env" name="Yazi" {
            args "YAZI_IDE_SIDEBAR=1" "nu" "/home/gence/.config/nushell/yazi-zx.nu"
            focus true
        }
        pane split_direction="Horizontal" {
            pane command="nu" name="Helix" {
                args "-c" "hx"
            }
            pane name="Terminal" size="25%"
        }
    }
}
```

**Yazi-ZX Opener (`yazi-zx/.config/yazi-zx/yazi.toml`)**
```toml
[opener]
text = [
    { run = '~/.config/yazi-zx/scripts/open_in_hx.sh "$@"', block = false, desc = "Open in Helix via Zellij" }
]
```

**Keymap Enhancements (`yazi-zx/.config/yazi-zx/keymap.toml`)**
- Disables `:` and `;` (no-op)
- Adds workspace guard navigation
- Adds confirm quit behavior

#### Usage Patterns

**Opening Multiple Files**
1. Navigate Yazi to target directory
2. Select multiple files with `v` (visual select) or `V`
3. Press `Enter` to open all in Helix tabs
4. Yazi reopens at current location (state preserved)

**Navigation Flow**
1. Navigate directories in Yazi (sidebar)
2. Cannot go above initial directory (workspace guard)
3. File opens automatically focus Helix editor
4. Return to Yazi by pressing `Alt+h` or navigate via `Alt+Arrow Keys`

**Switching Panes**
- `Alt+h/j/k/l`: Move focus between panes
- `Alt+n`: Create new pane
- `Alt+p`: Switch to previous pane
- `Alt+e`: Switch to next swap layout

**Layout Variants**
- `Alt+[`: Previous layout (no_sidebar, no_terminal, zen)
- `Alt+]`: Next layout

#### Environment Variables

The workflow relies on these environment variables:

- `YAZI_CONFIG_HOME`: Points to `~/.config/yazi-zx` for IDE-specific config
- `YAZI_IDE_SIDEBAR=1`: Flag indicating Yazi runs in sidebar mode
- `YAZI_ZX_ROOT`: Tracks the initial working directory (workspace root)
- `YAZI_SELECTION_FILE`: `/tmp/yazi_selection` (selected file paths)
- `YAZI_CWD_FILE`: `/tmp/yazi_cwd` (current working directory)

#### Debugging

Logs written to `/tmp/yazi_zellij_debug.log` by `open_in_hx.sh`:
- Timestamp of script execution
- Arguments received (file paths)
- Resolved absolute paths
- Zellij action results

#### Differences from Standard Yazi

The yazi-zx configuration differs from standard yazi in several ways:

1. **Workspace Locking**: Cannot navigate above initial directory
2. **Persistent Mode**: Yazi reopens after file selection (vs. exit)
3. **IDE Integration**: File opens route through Zellij to Helix
4. **Custom Keybinds**: Modified navigation and quit behavior
5. **Status Bar**: Hidden for cleaner sidebar appearance
6. **Open Behavior**: Default `Enter` triggers custom opener script

### Nushell Yazi Integration

The `y` function in `nushell/.config/nushell/config.nu` provides standard Yazi usage with directory persistence:

```nu
def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  ^yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp | str trim)
  if (not ($cwd | is-empty)) and ($cwd != $env.PWD) and ($cwd | path exists) {
    cd $cwd
  }
  rm -f $tmp
}
```

Usage: `y [path]` - Opens Yazi, then `cd` to final location on exit.

### Helix Editor Integration

Helix is configured as the primary editor with:
- **Theme**: monokai_spectrum_custom
- **Relative line numbers**: Easier navigation with `j`/`k`
- **Language servers**: Configured for TypeScript, JavaScript, CSS, SCSS
- **Auto-format**: Prettier for web languages
- **File encoding**: UTF-8 default

## General Conventions

No automated tests exist in this repository. Changes should be manually tested by:

1. Stowing/unstowing the affected package
2. Verifying the application loads the configuration correctly
3. Testing functionality in a safe environment

## Common Tasks

- **Add new Yazi plugin**: Create directory under `plugins/`, add `main.lua` with `setup/entry/fetch` functions
- **Add new Helix keybinding**: Edit `config.toml` under `[keys.normal]` or `[keys.insert]` sections
- **Add new shell script**: Place in `home/.local/bin/`, make executable, update README
- **Update theme**: Modify `theme.toml` files or create new flavors in `flavors/` directories
