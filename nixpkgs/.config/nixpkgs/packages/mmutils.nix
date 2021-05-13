{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "mmutils";
  version = "1.4.1";

  src = pkgs.fetchFromGitHub {
    owner = "pockata";
    repo = "mmutils";
    rev = "v${version}";
    sha256 = "08wlb278m5lr218c87yqashk7farzny51ybl5h6j60i7pbpm01ml";
  };

  buildInputs = with pkgs; [ xorg.libxcb ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A set of utilities to easily get xrandr monitor information";
    homepage = "https://github.com/pockata/mmutils";
    license = pkgs.lib.licenses.isc;
    platforms = pkgs.lib.platforms.all;
  };
}
