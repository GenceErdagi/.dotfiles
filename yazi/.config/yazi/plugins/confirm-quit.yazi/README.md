# confirm-quit.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin that requires confirmation before quitting by pressing `q` twice within 3 seconds.

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) v25.5.31+

## Installation

```bash
ya pkg add genceerdagi/confirm-quit
```

## Usage

Add this to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
desc = "Exit (with confirmation)"
on = "q"
run = "plugin confirm-quit"
```

## How It Works

1. First press of `q` shows a notification: "Press 'q' again within 3s to quit Yazi"
2. Second press within 3 seconds actually quits Yazi
3. If more than 3 seconds pass, the confirmation resets

## License

MIT
