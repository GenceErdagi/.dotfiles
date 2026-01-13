# ZIDE - Zellij IDE Controller Plugin

## Overview
**ZIDE** is a custom Rust-based Zellij plugin designed to create a toggleable, IDE-like environment. It allows you to launch a specific layout (Sidebar + Helix + Terminal) and toggle the visibility of the sidebar and terminal panes using keyboard shortcuts, solving the limitation of static KDL layouts.

## Features
- **One-Command Launch:** `zide` command sets up the entire environment.
- **Toggleable Panes:** 
  - `Alt+e`: Toggle Yazi (File Explorer) Sidebar.
  - `Alt+t`: Toggle Terminal (Bottom Pane).
- **Auto-Resize:** Automatically attempts to restore pane sizes (15% sidebar, 25% terminal) when toggling them back on.
- **Clean Interface:** The controller plugin hides itself after initialization.

## Architecture
The plugin operates in two modes:
1.  **Bootstrapper:** When first launched, it spawns a new Tab with the defined IDE layout string (embedded in the binary).
2.  **Controller:** Inside the new tab, it runs as a hidden pane (`mode="controller"`), listening for keybindings and managing pane visibility.

## Source Code
The source code is located at: `~/.dotfiles/zellij/zide-plugin/src/lib.rs`

## Build & Deploy
To update the plugin logic:
1.  Edit `src/lib.rs`.
2.  Run the build command:
    ```bash
    cargo build --target wasm32-wasip1 --release
    ```
3.  **Versioning:** You MUST copy the output `zide_plugin.wasm` to a new filename (e.g., `zide_plugin_v13.wasm`) and update `src/lib.rs` (the layout string) AND `config.nu` to point to the new version. This is required to bypass Zellij's aggressive WASM caching.

## Configuration
The layout and keybindings are defined directly inside `src/lib.rs`.

### Current Layout Structure
```kdl
tab name="IDE" focus=true {
    pane split_direction="vertical" {
        pane size="15%" command="yazi" name="Yazi" { args "yazi_pwd"; }
        pane split_direction="Horizontal" {
            pane command="hx" name="helix" { focus true; }
            pane command="nu" name="Terminal" size="25%"
        }
    }
    pane size=1 borderless=true {
        plugin location="..." { mode "controller"; }
    }
}
```

## Dependencies
- `zellij-tile`: 0.43.1 (Matches installed Zellij version)
- `wasm32-wasip1` Rust target.
