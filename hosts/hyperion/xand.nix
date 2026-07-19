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
    ../../sw/vscodium
  ];

  home.homeDirectory = "/home/xand";
  home.username = "xand";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    coppwr
    pwvucontrol
    recordbox
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
