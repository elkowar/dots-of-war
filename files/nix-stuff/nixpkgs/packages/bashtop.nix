{ stdenv, fetchFromGitHub, gnumake }:
stdenv.mkDerivation rec {
  pname = "bashtop";
  version = "0.9.9";
  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gw9mslnq1f8516jd7l2ajh07g7a45z834jslpjai17p2ymhng9c";
  };

  nativeBuildInputs = [ gnumake ];
  installFlags = [ "PREFIX=$(out)" ];
}
