fish_vi_key_bindings
# fish_default_key_bindings

alias ls=lsd
abbr --add --global vim nvim
abbr --add --global tsh trash
abbr --add --global clear "clear && ls"
abbr --add --global cxmonad "nvim /home/leon/.xmonad/lib/Config.hs"



abbr --add --global gaa "git add --all"
abbr --add --global gc "git commit -m "
abbr --add --global gp "git push"


[ (hostname) = "garnix" ] && alias rm='echo "rm is disabled. Please use trash instead."; false'
