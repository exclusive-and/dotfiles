{
  config
, lib
, pkgs
, ...
}:

{
  imports = [
    ../../sw/direnv
    ../../sw/easyeffects
    ../../sw/firefox
    ../../sw/fish
    ../../sw/git
    ../../sw/opencomposite
    ../../sw/vscodium
  ];

  home.homeDirectory = "/home/gaming";
  home.username = "gaming";
  home.stateVersion = "24.11";

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  home.packages = with pkgs; [
    coppwr
    discord
    heroic
    opencomposite
    pwvucontrol
    recordbox
    unzip
    zip
  ];

  news.display = "silent";

  programs.home-manager.enable = true;

  gtk.enable = true;
  gtk.iconTheme = {
    name = "Kanagawa";
    package = pkgs.kanagawa-icon-theme;
  };
  gtk.theme = {
    name = "Kanagawa-B";
    package = pkgs.kanagawa-gtk-theme;
  };
  gtk.gtk4.theme = config.gtk.theme;
}
