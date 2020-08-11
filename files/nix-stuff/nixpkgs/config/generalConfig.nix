{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.generalConfig;
  myConf = import ../myConfig.nix;
in
{
  options.elkowar.generalConfig = with lib; {
    shellAbbrs = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        A map of abbreviations that will get applied to zsh and fish configuration.
      '';
    };
  };
  config = {
    elkowar.programs.zsh.abbrs = cfg.shellAbbrs;
    programs.fish.shellAbbrs = cfg.shellAbbrs;
  };
}
