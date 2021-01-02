{ fetchFromGitHub, stdenvNoCC, lib, makeWrapper, gitAndTools, bat, extraPackages ? [] }:
let
  binPath = lib.makeBinPath ([gitAndTools.hub gitAndTools.delta bat] ++ extraPackages);
in
stdenvNoCC.mkDerivation rec {
  pname = "git-fuzzy";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = "git-fuzzy";
    rev = "ecdcd157e537d98586435a40bed83d40c65bd959";
    sha256 = "1f2iq8bk0fpld99m0siajadn3lr5fwvgwpniwfdh73picxa7hwhk";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -m755 -D ./bin/git-fuzzy $out/bin/git-fuzzy
    install -d "$out/lib"
    cp -r lib "$out/lib/git-fuzzy"

  '';
  postFixup = ''
    sed -i 's%lib_dir="$script_dir/../lib"%lib_dir='"$out"'/lib/git-fuzzy%' $out/bin/git-fuzzy
    wrapProgram "$out/bin/git-fuzzy" --prefix PATH : ${binPath}
  '';
  meta = {
    description = "FZF-based github cli interface";
    homepage = "https://github.com/bigH/git-fuzzy";
    maintainers = with lib.maintainers; [ elkowar ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

#"build() {
  #cd "${srcdir}/${_pkgname}"
  #sed -i 's%lib_dir="$script_dir/../lib"%lib_dir=/usr/lib/git-fuzzy%' bin/git-fuzzy

  #sed -i 's%gifs/%https://github.com/bigH/git-fuzzy/raw/master/gifs/%' README.md
#}"
