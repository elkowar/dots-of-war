fish_vi_key_bindings
# fish_default_key_bindings

alias ls=lsd
abbr --add --global vim nvim
abbr --add --global tsh trash
abbr --add --global clear "clear && ls"


[ (hostname) = "garnix" ] && alias rm='echo "rm is disabled. Please use trash instead."; false'
