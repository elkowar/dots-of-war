#!/usr/bin/env zsh
# fzf-tab configuration -- https://github.com/Aloxaf/fzf-tab/wiki/Configuration

# REQUIRED: disable zsh's own completion menu so fzf-tab can take over.
zstyle ':completion:*' menu no

# Enable filename colorizing in completion lists.
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Show group/category headers (e.g. [files], [aliases]).
zstyle ':completion:*:descriptions' format '[%d]'

# Don't sort option lists (preserve definition order).
zstyle ':completion:complete:*:options' sort false

# Use fzf-tab's grouping with one header per group.
zstyle ':fzf-tab:*' show-group full

# Use the current input as the initial query for some completions.
zstyle ':fzf-tab:complete:cd:*'         query-string input
zstyle ':fzf-tab:complete:__zoxide_z:*' query-string input

# Switch between groups using < and >.
zstyle ':fzf-tab:*' switch-group '<' '>'

# Press space to continue completing the next directory after a match.
zstyle ':fzf-tab:*' continuous-trigger 'space'

# Sensible defaults for the fzf process fzf-tab spawns.
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --tiebreak=begin --cycle --bind=ctrl-space:toggle

# Use tmux popup when inside tmux (falls back to inline fzf otherwise).
if [[ -n "$TMUX" ]]; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi

# ---- previews -------------------------------------------------------------

# Directory preview helper -- prefers eza, then lsd, then ls.
_fzf_tab_preview_dir() {
  if command -v eza >/dev/null; then
    eza -1 --color=always --icons "$realpath"
  elif command -v lsd >/dev/null; then
    lsd -1 --color=always "$realpath"
  else
    ls -1 --color=always "$realpath"
  fi
}

# File preview helper -- delegates to directory preview if it's a directory,
# uses bat if available, falls back to head otherwise.
_fzf_tab_preview_file() {
  if [[ -d "$realpath" ]]; then
    _fzf_tab_preview_dir
  elif command -v bat >/dev/null; then
    bat --style=numbers --color=always --line-range :200 "$realpath"
  else
    head -200 "$realpath" 2>/dev/null
  fi
}

zstyle ':fzf-tab:complete:cd:*'         fzf-preview '_fzf_tab_preview_dir'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview '_fzf_tab_preview_dir'
zstyle ':fzf-tab:complete:*:*'          fzf-preview '_fzf_tab_preview_file'

# Preview man pages.
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word 2>/dev/null | head -200'

# Preview environment variables / parameters.
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

# Preview processes when completing kill arguments.
zstyle ':fzf-tab:complete:(\\|*/|)kill:argument-rest' \
  fzf-preview 'ps -p $word -o args -o user -o pid 2>/dev/null'

# Preview git objects (commits / branches / etc.) when completing git subcommands.
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'git diff --color=always $word 2>/dev/null | head -200'
zstyle ':fzf-tab:complete:git-(log|show):*' fzf-preview \
  'git log --color=always --oneline --decorate $word 2>/dev/null | head -200'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'git log --color=always --oneline --decorate $word 2>/dev/null | head -200'
