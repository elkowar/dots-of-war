# ----------------------------------------------------------------------------
# .zshenv -- sourced for ALL zsh invocations (login, interactive, scripts).
# Only put environment variables and PATH here. Interactive-only config
# (aliases, prompt, keybinds, plugins) belongs in .zshrc.
# ----------------------------------------------------------------------------

# zsh config directory
ZDOTDIR="$HOME/.config/zsh"

# XDG base dirs (used by HISTFILE, NVM, etc.)
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Editor
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man! +"set nocul" +"set noshowcmd" +"set noruler" +"set noshowmode" +"set laststatus=0"'

# Toolchain envs
export PNPM_HOME="$HOME/.local/share/pnpm"
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
[ -d "$NVM_DIR" ] || NVM_DIR="$HOME/.nvm"
export NVM_DIR
export SDKMAN_DIR="$HOME/.sdkman"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK="$HOME/Android/Sdk/ndk/21.4.7075529"

# JAVA_HOME -- prefer macOS's libexec helper, fall back to a generic Linux path.
if [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
elif [[ -d /usr/lib/jvm/default-java ]]; then
  export JAVA_HOME="/usr/lib/jvm/default-java"
fi

# ----------------------------------------------------------------------------
# PATH -- consolidated. `typeset -U path PATH` deduplicates automatically;
# `(N-/)` is a glob qualifier that silently skips entries whose directory
# doesn't exist on this machine.
# ----------------------------------------------------------------------------
typeset -U path PATH
path=(
  "$HOME/.deno/bin"(N-/)
  "$HOME/.pub-cache/bin"(N-/)
  "/Applications/WezTerm.app/Contents/MacOS"(N-/)
  "$HOME/fvm/bin"(N-/)
  "$HOME/.bun/bin"
  "$HOME/.local/bin"
  "$HOME/.volta/bin"
  "$PNPM_HOME"
  $path
)

# Cargo env (may add $HOME/.cargo/bin to PATH; typeset -U keeps it unique).
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Nix (Linux locations -- harmless if missing).
[ -e /home/leon/.nix-profile/etc/profile.d/nix.sh ] && . /home/leon/.nix-profile/etc/profile.d/nix.sh
[ -e /home/elk/.nix-profile/etc/profile.d/nix.sh ]  && . /home/elk/.nix-profile/etc/profile.d/nix.sh
