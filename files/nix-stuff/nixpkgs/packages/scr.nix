{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "scr";
  version = "2.0";
  src = pkgs.fetchFromGitHub {
    owner = "6gk";
    repo = "scr";
    rev = "v${version}";
    sha256 = "18srzjkbhh3n10ayq5nnbnx37vjfzfw0adhkwbg1s157y8hfnlcy";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = "install -m755 -D ./scr $out/bin/scr";
  postFixup = ''
    wrapProgram "$out/bin/scr" --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [ slop ffmpeg dmenu xclip shotgun ])}
  '';
  meta = {
    description = "Super CRappy SCReenshot SCRipt";
    longDescription = ''
      Super CRappy SCReenshot SCRipt
              (and recording ^)
      A SCRipt for Sound Cloud Rappers
    '';
    homepage = "https://github.com/6gk/scr";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.all;
  };
}
