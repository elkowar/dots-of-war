{ pkgs ? import <nixpkgs> { } }:
with pkgs; python38Packages.buildPythonPackage rec {
  pname = "DiscordOverlayLinux";
  version = "f71b6c9c345cd8df131a431bcbeabcc79159be99";
  src = fetchFromGitHub {
    owner = "trigg";
    repo = "DiscordOverlayLinux";
    rev = "${version}";
    sha256 = "0wrm1l3f8irzn62lqbnxk8k6jpkhz0h7nnqn51sa3m43pdi787f1";
  };

  propagatedBuildInputs = [ python38Packages.pyqt5 python38Packages.pyqtwebengine python38Packages.pyxdg qt5.qtwebengine ];



  doCheck = false;
}
