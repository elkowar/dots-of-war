{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "boox";
  src = pkgs.fetchFromGitHub {
    owner = "BanchouBoo";
    repo = "boox";
    rev = "bbbb883436d505b5f85cbb3024d14c82da548d9b";
    sha256 = "1xy3g1gyzhmm87cg5dyal55ysj2zrfzk2myrws5v0ck63zyq5593";
  };

  buildInputs = with pkgs; [ xorg.libxcb xorg.xcbutilcursor pkgconfig ];
  installFlags = [ "PREFIX=$(out)" ];
}
