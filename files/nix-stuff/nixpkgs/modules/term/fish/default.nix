{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.programs.fish;
  myConf = import ../myConfig.nix;
  sources = import ../../../nix/sources.nix;
in
{
  options.elkowar.programs.fish = {
    enable = lib.mkEnableOption "Fish configuration";
  };
  config = {
    programs.fish = {
      enable = true;
      functions = {
        fish_prompt = builtins.readFile ./fish-prompt.fish;
        fish_greeting = "";
        fish_mode_prompt = "";

      };

      shellAliases = {
        ls = "exa --icons";
      };

      plugins = [
        { name = "fzf"; src = sources.fish-fzf-tab; }
        { name = "foreign-env"; src = sources.plugin-foreign-env; }
        { name = "base16-fish"; src = sources.base16-fish; }
      ];

      shellInit = ''
        fish_vi_key_bindings

        #set -U FZF_TMUX 1
        set -U FZF_DEFAULT_COMMANDS "--filepath-word --cycle"
        set -U FZF_PREVIEW_FILE_CMD "head -n 10 | bat --color=always --decorations=never"
        set -U fish_greeting


        base16-gruvbox-dark-medium

        #if status is-interactive
        #and not set -q TMUX
            #exec tmux
        #end


        [ (hostname) = "garnix" ] && alias rm='echo "rm is disabled. Please use trash instead."; false'

        function run_pipr
          set -l commandline (commandline -b)
          pipr --out-file /tmp/pipr_out --default "$commandline"
          set -l result (cat /tmp/pipr_out)
          commandline -r $result
          commandline -f repaint
        end

        bind \ca run_pipr

        function c
          set -l result (/home/leon/scripts/conf)
          commandline -r "$result"
          commandline -f execute
        end


        function replace_with_yay
          set -l cmd (commandline -b)
          switch $cmd
          case "*pacman*"
            set edited (echo $cmd | sed 's/sudo //g' | sed 's/pacman/yay/g')
          case "yay*"
            set edited (echo $cmd | sed 's/yay/sudo pacman/g')
          end
          commandline -r "$edited"
          commandline -f repaint
        end

        bind \cy replace_with_yay

        # fff file manager cd on exit
        function f
            fff $argv
            set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
            cd (cat $XDG_CACHE_HOME/fff/.fff_d)
        end
        set -x EDITOR "nvim"
        set -x FFF_TRASH_CMD "trash" # make fff's trash function use trash-cli

        fenv source '$HOME/.nix-profile/etc/profile.d/nix.sh'
        set -g NIX_PATH "$HOME/.nix-defexpr/channels:$NIX_PATH"
        fenv source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      '';
    };
  };
}
