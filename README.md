# Dotfiles

This repository contains my configuration files managed with GNU Stow.

## Overview

This repository uses GNU Stow to manage dotfiles symlinks. Each subdirectory represents a "package" that can be stowed to create symlinks in the home directory.

## Packages

- **helix**: Configuration for the Helix text editor
- **yazi**: Configuration for the Yazi file manager
- **zellij**: Configuration for the Zellij terminal multiplexer
- **nushell**: Configuration for the Nushell shell
- **home**: Configuration files in the home directory (`.bashrc`, `.gitconfig`, etc.) and user scripts in `~/.local/bin`

## Installation / Restore

### Prerequisites

Install GNU Stow:

```bash
# Ubuntu/Debian
sudo apt install stow

```

### Stow Configuration

To install all configurations:

```bash
cd ~/dotfiles
stow helix yazi zellij nushell home -t ~
```

To install individual configurations:

```bash
# For example, to install only helix configuration
stow helix -t ~
```

### Unstow Configuration

To remove symlinks (unstow):

```bash
# Remove all configurations
stow -D helix yazi zellij nushell home -t ~

# Remove individual configuration
stow -D helix -t ~
```

## User Scripts

The `home` package includes user scripts in `~/.local/bin`:

- **yazi_pwd**: A wrapper script for Yazi that remembers the current working directory and opens selected files in Helix via Zellij
- **open_in_hx.sh**: A script used by Yazi to open files in Helix via Zellij

## Structure

The repository is organized as follows:

```
dotfiles/
├── helix/          # Helix editor configuration
│   └── .config/
│       └── helix/
├── yazi/           # Yazi file manager configuration
│   └── .config/
│       └── yazi/
├── zellij/         # Zellij terminal multiplexer configuration
│   └── .config/
│       └── zellij/
├── nushell/        # Nushell configuration
│   └── .config/
│       └── nushell/
└── home/           # Home directory configuration files
    ├── .bashrc
    ├── .gitconfig
    └── ...
```

