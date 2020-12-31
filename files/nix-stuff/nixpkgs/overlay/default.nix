let
  sources = import ../nix/sources.nix;
in
self: super: {
  alacritty = super.callPackage ../packages/alacritty-overlay.nix { alacritty = super.alacritty; };
  bashtop = super.callPackage ../packages/bashtop.nix { };
  boox = super.callPackage ../packages/boox.nix { };
  cool-retro-term = super.callPackage ./cool-retro-term.nix { cool-retro-term = super.cool-retro-term; };
  carp-new = super.callPackage ./carp-new.nix {};
  liquidctl = super.callPackage ../packages/liquidctl.nix { };
  mmutils = super.callPackage ../packages/mmutils.nix { };
  nixGL = import sources.nixGL { };
  scr = super.callPackage ../packages/scr.nix { };
  my-st = super.callPackage ../packages/st/st-tanish2002 { };
  kmonad = import "${sources.kmonad}/nix";
}
