fish_vi_key_bindings
# fish_default_key_bindings

set -U FZF_TMUX 1
set -U FZF_PREVIEW_FILE_CMD "head -n 10 | bat --color=always --decorations=never"


alias ls=lsd
abbr --add --global vim nvim
abbr --add --global tsh trash
#abbr --add --global clear "clear && ls"
abbr --add --global cxmonad "nvim /home/leon/.xmonad/lib/Config.hs"


if status is-interactive
and not set -q TMUX
    exec tmux
end

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


# fff file manager cd on exit
function f
    fff $argv
    set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
    cd (cat $XDG_CACHE_HOME/fff/.fff_d)
end
set -x EDITOR "nvim"
set -x FFF_TRASH_CMD "trash" # make fff's trash function use trash-cli

