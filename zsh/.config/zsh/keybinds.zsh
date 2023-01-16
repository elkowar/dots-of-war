# This file is currently mostly stolen from https://github.com/druskus20/dots/blob/master/zsh/.config/zsh/modules/keybinds.zsh
# Vi mode {{{
bindkey -v

# https://superuser.com/questions/476532/how-can-i-make-zshs-vi-mode-behave-more-like-bashs-vi-mode
export KEYTIMEOUT=1   # Vi mode timeout for key sequences
bindkey -M vicmd '^[' undefined-key

# Remove keybinds that begin with esc (so ESC doesnt hang)
bindkey -M vicmd -r "^[OA"    # up-line-or-history
bindkey -M vicmd -r "^[OB"    # down-line-or-history
bindkey -M vicmd -r "^[OC"    # vi-forward-char
bindkey -M vicmd -r "^[OD"    # vi-backward-char
bindkey -M vicmd -r "^[[200~" # bracketed-paste
bindkey -M vicmd -r "^[[A"    # up-line-or-history
bindkey -M vicmd -r "^[[B"    # down-line-or-history
bindkey -M vicmd -r "^[[C"    # vi-forward-char
bindkey -M vicmd -r "^[[D"    # vi-backward-char

# Remove execute because Im dumb
bindkey -M vicmd -r ":"       # execute

bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
                 '^X/' _history-complete-older \
                 '^X`' _bash_complete-word

# Don't use vi mode in backward delete word/char because it cannot delete
# characters on the left of position you were in insert mode.
bindkey "^?" backward-delete-char
# }}}

# Pipr thing {{{
_pipr_expand_widget() {
  emulate -LR zsh
  </dev/tty pipr --out-file /tmp/pipr_out --default "$LBUFFER" >/dev/null
  LBUFFER=$(< /tmp/pipr_out)
}
zle -N _pipr_expand_widget
bindkey '\ea' _pipr_expand_widget
#}}}

# Keybindings 

# delete word but break on slashes
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word

bindkey "^[[1;5C" forward-word            # C-ArrowRight
bindkey "^[[1;5D" backward-word           # C-ArrowLeft
bindkey "\e[3~"   delete-char             # Del
bindkey "^E"      end-of-line             # C-E
bindkey "^[[F"    end-of-line             # END
bindkey "^[[4~"   end-of-line             # END
bindkey "^[[H"    beginning-of-line       # HOME
bindkey "^[[1~"   beginning-of-line       # HOME
bindkey "^A"      beginning-of-line       # C-A
bindkey '^W'      my-backward-delete-word # C-w
bindkey '^H'      my-backward-delete-word # C-backspace
bindkey "^[."     insert-last-word        # alt-.
bindkey "^[[3~"   delete-char             # DEL
bindkey "^R"      history-incremental-search-backward # C-R

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# C-Q to edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M viins "^Q" edit-command-line
bindkey -M vicmd "^Q" edit-command-line

setopt NO_FLOW_CONTROL  # Disable Ctrl+S and Ctrl+Q 
