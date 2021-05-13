{ lib, stdenv, fetchFromGitHub, makeWrapper, clang, haskellPackages }:

haskellPackages.mkDerivation rec {

  pname = "carp";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "carp-lang";
    repo = "Carp";
    #rev = "v${version}";
    rev = "6c551a104b96b8a9b3698a5da738e0bf796076ca";
    sha256 = "0f20grjpg3xz607lydj7pdrzwibimbk7wfw5r4mg8iwjqgbp22vw";
  };

  buildDepends = [ makeWrapper ];

  executableHaskellDepends = with haskellPackages; [
    HUnit blaze-markup blaze-html split cmdargs ansi-terminal cmark
    edit-distance optparse-applicative hashable open-browser
  ];

  isExecutable = true;

  # The carp executable must know where to find its core libraries and other
  # files. Set the environment variable CARP_DIR so that it points to the root
  # of the Carp repo. See:
  # https://github.com/carp-lang/Carp/blob/master/docs/Install.md#setting-the-carp_dir
  #
  # Also, clang must be available run-time because carp is compiled to C which
  # is then compiled with clang.
  postInstall = ''
    wrapProgram $out/bin/carp                                  \
      --set CARP_DIR $src                                      \
      --prefix PATH : ${clang}/bin
    wrapProgram $out/bin/carp-header-parse                     \
      --set CARP_DIR $src                                      \
      --prefix PATH : ${clang}/bin
  '';

  description = "A statically typed lisp, without a GC, for real-time applications";
  homepage    = "https://github.com/carp-lang/Carp";
  license     = stdenv.lib.licenses.asl20;
  maintainers = with stdenv.lib.maintainers; [ jluttine ];

  # Windows not (yet) supported.
  platforms   = with stdenv.lib.platforms; unix ++ darwin;

}
