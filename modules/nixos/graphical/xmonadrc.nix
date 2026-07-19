{
  mkDerivation
, lib

, cabal-install
, haskell-language-server
, shellFor

, base
, containers
, data-default
, X11
, xmonad
, xmonad-contrib
, xmonad-extras
}:

lib.fix (
  xmonadrc: mkDerivation {
    pname = "xmonadrc";
    src = ./.;
    version = "1.0";
    isExecutable = true;
    isLibrary = false;
    executableHaskellDepends = [
      base
      containers
      X11
      xmonad
      xmonad-contrib
      xmonad-extras
    ];
    passthru.devShell = shellFor {
      packages = _: [
        xmonadrc
      ];
      buildInputs = [
        cabal-install
        haskell-language-server
      ];
      nativeBuildInputs = [
        cabal-install
      ];
    };
    mainProgram = "xmonadrc";
    homepage = "https://github.com/exclusive-and/dotfiles";
  }
)
