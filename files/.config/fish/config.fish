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
abbr --add --global gs "git status"


[ (hostname) = "garnix" ] && alias rm='echo "rm is disabled. Please use trash instead."; false'

function run_stuff
  set -l commandline (commandline -b)
  pipr --out-file /tmp/pipr_out --default "$commandline"
  set -l result (cat /tmp/pipr_out)
  commandline -r $result
  commandline -f repaint
end

bind \ca run_stuff


