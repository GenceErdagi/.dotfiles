# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). The `home/` package
mirrors `$HOME`, so stowing it places everything in the right spot.

## Bootstrap

```sh
cd ~/.dotfiles
stow --dotfiles -t ~ home
```

This creates symlinks like `~/.zshrc -> ~/.dotfiles/home/dot-zshrc` and
`~/.config/eza/theme.yml -> ~/.dotfiles/home/.config/eza/theme.yml`.

## Updates

```sh
cd ~/.dotfiles
git pull
stow --dotfiles -t ~ home
```

## Unstow

```sh
cd ~/.dotfiles
stow --dotfiles -D -t ~ home
```

## Notes

- `gh` config is **not** tracked (contains auth tokens).
- `nextjs-nodejs` config is not tracked.
- `opencode` tracks only `opencode.jsonc`; plugin install artifacts are ignored.
