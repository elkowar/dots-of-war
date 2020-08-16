{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "scr";
  version = "1.0";
  src = pkgs.fetchFromGitHub {
    owner = "6gk";
    repo = "scr";
    rev = "v${version}";
    sha256 = "1pq0w3qpap6rsgxashphq5xlhvdyhryjaz7dh0l5rfmh7ydpzf12";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = "install -m755 -D ./scr $out/bin/scr";
  postFixup = ''
    wrapProgram "$out/bin/scr" --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [ slop ffmpeg dmenu xclip shotgun ])}
  '';
  meta = {
    description = "a screenrecording / screenshotting script written in sh.";
    homepage = "https://github.com/6gk/scr";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.all;
  };
}


#let

#scr = pkgs.fetchFromGitHub {
#owner = "6gk";
#repo = "scr";
#rev = "4064159e291e59f4543a676b872c91fe049a3f1e";
#sha256 = "1pq0w3qpap6rsgxashphq5xlhvdyhryjaz7dh0l5rfmh7ydpzf12";
#};
#in
#pkgs.runCommand "scr"
#{ buildInputs = with pkgs; [ slop ffmpeg dmenu xclip shotgun ]; }
#''
#mkdir -p $out/bin
#cp ${scr}/scr $out/bin/scr
#sed -i "2 i export PATH=$PATH" $out/bin/scr
#''
