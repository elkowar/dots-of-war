{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.generalConfig;
  myConf = import ../myConfig.nix;
in
{
  options.elkowar.generalConfig = with lib; {
    shellAliases = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        A map of aliases that will get applied to zsh and fish configuration.
      '';
    };
  };
  config = {
    programs.zsh.shellAliases = cfg.shellAliases;
  };
}
