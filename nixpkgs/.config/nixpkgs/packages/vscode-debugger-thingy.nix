{ fetchFromGitHub, stdenvNoCC, lib, makeWrapper, extraPackages ? [] }:
let
  binPath = lib.makeBinPath ([] ++ extraPackages);
in
stdenvNoCC.mkDerivation rec {
  pname = "scr";
  version = "2.1";
  src = fetchFromGitHub {
    owner = "6gk";
    repo = "scr";
    rev = "v${version}";
    sha256 = "0fgmv99zlppi5wa2qylbvnblk9kc6i201byz8m79ld8cwiymabi2";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = "install -m755 -D ./scr $out/bin/scr";
  postFixup = ''
    wrapProgram "$out/bin/scr" --prefix PATH : ${binPath}
  '';
  meta = {
    description = "Super CRappy SCReenshot SCRipt";
    longDescription = ''
      Super CRappy SCReenshot SCRipt
              (and recording ^)
      A SCRipt for Sound Cloud Rappers
    '';
    homepage = "https://github.com/6gk/scr";
    maintainers = with lib.maintainers; [ elkowar ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
