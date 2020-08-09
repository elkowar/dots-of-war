{ pkgs ? import <nixpkgs> {} }:
with pkgs; python38.pkgs.buildPythonApplication rec {
  pname = "liquidctl";
  version = "1.4.1";

  propagatedBuildInputs = with python38.pkgs; [ pyusb docopt hidapi ];
  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "13gzfanxdrn45cwz9mm1j7jxxpwmdvz02i122ibimrzkndjvr8sr";
  };
  doCheck = false;
}
