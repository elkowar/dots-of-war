{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  pname = "fet.sh";
  version = "1.1";
  src = pkgs.fetchFromGitHub {
    owner = "6gk";
    repo = "fet.sh";
    rev = "v${version}";
    sha256 = "16b78w8fykpildyhhhf8xfvq95x97768xm7cqkcpp3vdmjzifq0w";
  };

  installPhase = "install -m755 -D ./fet.sh $out/bin/fet.sh";
  postBuild = ''sed -i 's/\[34m/\[36m/g' ./fet.sh'';
  meta = {
    description = "A fetch written in posix shell without any external commands (linux only)";
    homepage = "https://github.com/6gk/scr";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
  };
}

