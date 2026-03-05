# workspace-guard.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin that prevents navigating beyond a defined workspace root. Designed for use with the ZX terminal IDE workflow, but can be used standalone.

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) v25.5.31+

## Installation

```bash
ya pkg add genceerdagi/workspace-guard
```

## Usage

This plugin is primarily designed to work with the ZX terminal IDE workflow. When the `YAZI_ZX_ROOT` environment variable is set, it prevents the user from navigating above the initial working directory.

### Standalone Usage

If you want to use this plugin standalone, set the `YAZI_ZX_ROOT` environment variable to your desired workspace root:

```bash
export YAZI_ZX_ROOT="$PWD"
yazi
```

### Configuration

Add this to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
desc = "Leave directory (with workspace guard)"
on = "h"
run = "plugin workspace-guard"
```

Or to intercept the quit command:

```toml
[[mgr.prepend_keymap]]
desc = "Quit (with workspace guard)"
on = "q"
run = "plugin workspace-guard -- quit"
```

## How It Works

1. When triggered, the plugin checks if `YAZI_ZX_ROOT` environment variable is set
2. If set, it compares the current working directory against the root
3. If at the root, it blocks navigation and shows a warning notification
4. Otherwise, it allows the normal `leave` behavior

## License

MIT
