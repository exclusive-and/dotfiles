{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./nixpkgs.nix
    ./peripherals.nix
    ./power.nix
    ../../modules/applications/alacritty.nix
    ../../modules/applications/steam.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/graphical/picom.nix
    ../../modules/nixos/graphical/rofi.nix
    ../../modules/nixos/graphical/xmonad-session.nix
    ../../modules/nixos/greet.nix
    ../../modules/nixos/users.nix
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    "key_wg0".file = ./secrets/key_wg0.age;
  };

  environment.systemPackages = [
    pkgs.custom-slack
    pkgs.custom-vimrc
    pkgs.lshw
    pkgs.ragenix
    pkgs.rsync
    pkgs.unzip
    pkgs.vim
    pkgs.zip
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME   = "nvidia";
    GBM_BACKEND         = "nvidia-drm";
    __GL_GSYNC_ALLOWED  = "1";
    __GL_VRR_ALLOWED    = "1";
    NVD_BACKEND         = "direct";
  };

  fonts.packages = with pkgs; [
    hasklig
    input-fonts
    monaspace
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts);

  home-manager.useGlobalPkgs = true;
  home-manager.users."xand" = import ./xand.nix;

  origami.audio.enable = true;
  origami.greet.enable = true;
  origami.rofi.enable = true;
  origami.xmonad.enable = true;
  origami.xmonad.users = ["xand"];

  origami.users."xand".audio = true;
  origami.users."xand".packages = [
    pkgs.bitwarden-desktop
    pkgs.coppwr
    pkgs.discord
    # pkgs.heroic
    pkgs.pwvucontrol
    pkgs.recordbox
  ];
  origami.users."xand".wheel = true;
  origami.users."xand".xmonad.enable = true;

  programs.dconf.enable = true;
  programs.fish.enable = true;

  security.polkit.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.dbus.enable = true;

  # See https://nixos.org/nixos/options.html.
  system.stateVersion = "20.09";
}
