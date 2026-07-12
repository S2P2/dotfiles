# dotfiles

Personal configuration files for setting up tmux consistently across machines.

## Requirements

- Git
- A recent version of tmux (tested with tmux 3.4)
- A terminal font that supports the symbols used by the Catppuccin theme

## Install

Clone this repository:

```sh
git clone https://github.com/S2P2/dotfiles.git ~/dotfiles
```

Back up an existing tmux configuration, if present, and create a symbolic link:

```sh
[ ! -e ~/.tmux.conf ] || mv ~/.tmux.conf ~/.tmux.conf.backup
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

Install the tmux plugin manager:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux:

```sh
tmux
```

Press `Ctrl+b`, followed by `Shift+i`, to install the configured plugins. To reload the configuration later, press `Ctrl+b`, followed by `r`.

## Included tmux plugins

- [TPM](https://github.com/tmux-plugins/tpm)
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- [Catppuccin for tmux](https://github.com/catppuccin/tmux)

> Initial repository setup and documentation were prepared with assistance from an AI coding agent.
