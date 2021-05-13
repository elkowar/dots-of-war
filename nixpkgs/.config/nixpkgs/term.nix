{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.locate;
in
  {
    options.term = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  }
