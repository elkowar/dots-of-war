{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.programs.tmux;
  myConf = import ../myConfig.nix;
in
{
  options.elkowar.programs.tmux = {
    enable = lib.mkEnableOption "Enable the tmux configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 10000;
      keyMode = "vi";
      shortcut = "y";
      terminal = "tmux-256color";
      customPaneNavigationAndResize = true;
      extraConfig = ''
        bind v split-window -h -c "#{pane_current_oath}"
        bind b split-window -v -c "#{pane_current_oath}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %
        set -g mouse on

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        unbind [
        bind < copy-mode
        unbind p
        bind > paste-buffer
        bind-key C-a set -g status off
        bind-key C-s set -g status on
        bind -T copy-mode-vi MouseDragEnd1Pane send-keys -M -X copy-pipe 'xclip -in -selection clipboard'

        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off
        set-window-option -g monitor-activity off
        set-option -g bell-action none
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = prefix-highlight;
        }

      ];
    };
  };
}
