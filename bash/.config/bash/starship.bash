# Source from ~/.bashrc after any other prompt configuration.
case $- in
    *i*) ;;
    *) return ;;
esac

# Starship is installed for this user by the setup instructions.
export PATH="$HOME/.local/bin:$PATH"
if command -v starship >/dev/null 2>&1; then
    if [ -n "${TMUX:-}" ] && [ -z "${STARSHIP_CONFIG:-}" ]; then
        export STARSHIP_CONFIG="$HOME/.config/starship-tmux.toml"
    fi
    eval "$(starship init bash)"
fi
