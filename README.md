# dotfiles

Personal tmux and Starship configuration for Linux workstations and VPS sessions over SSH.
Validated with tmux 3.6 on Ubuntu, including clipboard copying to foot on Omarchy.

## Features

- Catppuccin Mocha colors configured directly in tmux; no theme plugin or special font required.
- Minimal Starship prompt in Mocha colors: mauve arrow, red after errors, duration after two seconds.
- Directory in the prompt outside tmux; active-pane directory and Git context in the tmux bar.
- Existing session/window names, prefix indicator, hostname, date, and time remain in the bar.
- Mouse selection, scrolling, pane switching, and border resizing.
- 50,000 lines of scrollback for new panes.
- Windows and panes numbered from 1; windows renumber automatically when closed.
- New windows and splits open in the active pane's directory.
- TPM manages tmux-resurrect and tmux-continuum.
- Workspace snapshots every 15 minutes and automatic restoration when a new tmux server starts.
- OSC 52 clipboard integration for copying from tmux to the local computer over SSH.

## Install

Requires Git, Python 3, Bash, curl, and tmux 3.6 or newer. The graphical terminal must support OSC 52 for clipboard integration.

```sh
git clone https://github.com/S2P2/dotfiles.git ~/dotfiles

# Install Starship for this user.
mkdir -p ~/.local/bin
curl -fsSL https://starship.rs/install.sh -o /tmp/starship-install.sh
sh /tmp/starship-install.sh -y -b ~/.local/bin

# Link prompt settings, Bash initialization, and the tmux context helper.
mkdir -p ~/.config/bash
for name in starship.toml starship-tmux.toml; do
    target="$HOME/.config/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "$target.backup-$(date +%Y%m%d-%H%M%S)"
    fi
    ln -s "$HOME/dotfiles/starship/.config/$name" "$target"
done
for name in .config/bash/starship.bash .local/bin/tmux-pane-context; do
    target="$HOME/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "$target.backup-$(date +%Y%m%d-%H%M%S)"
    fi
    case "$name" in
        .config/bash/*) ln -s "$HOME/dotfiles/bash/$name" "$target" ;;
        *) ln -s "$HOME/dotfiles/tmux/$name" "$target" ;;
    esac
done

# Back up an existing configuration, including a symbolic link.
if [ -e ~/.tmux.conf ] || [ -L ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.backup-$(date +%Y%m%d-%H%M%S)
fi
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Skip this clone if TPM is already installed at this path.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new-session -A -s main
```

Add this once at the end of `~/.bashrc`, replacing any existing Starship initialization:

```sh
. "$HOME/.config/bash/starship.bash"
```

Run `source ~/.bashrc` in each existing Bash shell, or open a new shell. The startup
snippet selects the minimal config inside tmux and the directory prompt outside it.
An explicitly set `STARSHIP_CONFIG` takes precedence. No Nerd Font is required.

If you attach to an existing server, reload with `tmux source-file ~/.tmux.conf`.
Press `Ctrl-b`, then `Shift-i` to install the plugins. Reload with `Ctrl-b`, then `r`.

The symlink means edits to `~/.tmux.conf` update the repository's configuration directly.
After pulling updates, reload the configuration and install any new plugins.

## Prompt and status bar

The prompt shows `❯` in Mocha mauve, changing to red after a failed command. Commands
that take at least two seconds show their duration beside the arrow. Outside tmux,
the working directory appears before the arrow.

Inside tmux, the status bar shows the active pane's directory and Git branch, with
`*` for working-tree changes and `↑` / `↓` for commits ahead of / behind the upstream.
The helper refreshes every three seconds, shortens long paths and branches, and
limits Git queries to one second. Git information is omitted outside repositories
or when a query times out. Existing host, date, time, session, and window information
is preserved.

Tracked files:

- `starship/.config/starship.toml`: prompt outside tmux.
- `starship/.config/starship-tmux.toml`: minimal prompt inside tmux.
- `bash/.config/bash/starship.bash`: Bash initialization.
- `tmux/.local/bin/tmux-pane-context`: Python helper for active-pane context.
- `tmux/.tmux.conf`: tmux theme, behavior, and status bar.

## Shortcuts

Press and release `Ctrl-b` before the second key.

| Second key | Action |
| --- | --- |
| `c` | New window in the current directory |
| `\|` or `%` | Split side by side in the current directory |
| `-` or `"` | Split top and bottom in the current directory |
| `h`, `j`, `k`, `l` | Select the pane to the left, below, above, or right |
| `r` | Reload configuration |
| `Shift-i` | Install plugins |
| `Shift-u` | Update plugins |
| `Ctrl-s` | Save workspace manually |
| `Ctrl-r` | Restore workspace manually |
| `d` | Detach; leave the session running |

## Session persistence

[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) saves sessions,
windows, pane layouts, working directories, and supported program commands to
`~/.tmux/resurrect/`. [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
saves every 15 minutes while the status bar is being refreshed and restores the
latest snapshot when a new tmux server starts. Save manually before a planned
shutdown to capture recent changes.

After rebooting, start tmux to trigger restoration. Automatic tmux startup at boot
is not configured. Snapshots rebuild the workspace; they do not preserve running
process memory or unsaved application state. Pane contents are not captured.

Keep continuum last in the plugin list and TPM after the theme: continuum adds
its autosave trigger to `status-right`.

## Clipboard over SSH

`set-clipboard external` lets tmux copy selections to the local terminal clipboard
using OSC 52. Test inside tmux:

```sh
tmux set-buffer -w 'tmux clipboard test'
```

Paste into a local editor. Mouse selection in tmux should also copy on release.
Applications inside tmux cannot directly set the clipboard with this setting.

If needed, enable clipboard writes in `~/.config/foot/foot.ini` on the local computer:

```ini
[security]
osc52=copy-enabled
```

Open a new foot instance afterward. For footclient, restart the foot server to
reload its configuration. Paste into foot with `Ctrl-Shift-v`.

## What belongs in Git

Track the configuration and documentation. Downloaded plugins, session snapshots,
local backups, and credentials stay outside this repository.
