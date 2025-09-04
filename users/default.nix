let
  createUser = import ./create-user.nix;
in
{
  xand = createUser {
    username = "xand";

    extraGroups = [
      "audio"
      "wheel"
    ];

    imports = [
      ../sw/direnv
      ../sw/easyeffects
      ../sw/firefox
      ../sw/fish
      ../sw/git
      ../sw/vscodium
    ];

    packages = pkgs: with pkgs; [
      coppwr
      pwvucontrol
      recordbox
    ];
  };

  gaming = createUser {
    username = "gaming";

    extraGroups = [
      "audio"
    ];

    imports = [
      ../sw/direnv
      ../sw/easyeffects
      ../sw/firefox
      ../sw/fish
      ../sw/git
      ../sw/opencomposite
      ../sw/vscodium
    ];

    packages = pkgs: with pkgs; [
      coppwr
      discord
      heroic-fix
      opencomposite
      pwvucontrol
      recordbox
    ];

    nixosImports = [
      ../sw/monado
      ../sw/steam
    ];
  };
}
