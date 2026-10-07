{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./nixpkgs.nix
    ./peripherals.nix

    ../../modules/nixos/alacritty.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/graphical/niri-session.nix
    ../../modules/nixos/graphical/picom.nix
    ../../modules/nixos/graphical/rofi.nix
    ../../modules/nixos/graphical/xmonad-session.nix
    ../../modules/nixos/greet.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/users.nix

    ../../sw/forgejo
    ../../sw/monado
    ../../sw/nginx
    ../../sw/slack
    ../../webhosts/coraless
  ];

  age.secrets = {
    "wireguard.privatekey".file = ./wireguard.privatekey.age;
  };

  environment.systemPackages = [
    pkgs.acpi
    pkgs.btop
    pkgs.custom-slack
    pkgs.custom-vimrc
    pkgs.lshw
    pkgs.nnn
    pkgs.ragenix
    pkgs.rsync
    pkgs.unzip
    pkgs.zip
  ];

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
  };

  fonts.packages = lib.foldl' (b: a: a ++ b) [] [
    [
      pkgs.hasklig
      pkgs.input-fonts
      pkgs.monaspace
    ]
    (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
  ];

  hardware.graphics.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    "xand" = import ./xand.nix;
    "gaming" = import ./gaming.nix;
  };
  
  origami.audio.enable = true;
  origami.greet.enable = true;
  origami.rofi.enable = true;
  origami.rofi.users = [ "xand" "gaming" ];
  origami.xmonad.enable = true;
  origami.niri.enable = true;
  origami.niri.users = [ "xand" "gaming" ];

  origami.users."xand" = {
    audio = true;
    packages = [
      pkgs.bitwarden-desktop
      pkgs.coppwr
      pkgs.pwvucontrol
      pkgs.recordbox
    ];
    wheel = true;
    # xmonad.enable = true;
  };

  origami.users."gaming" = {
    audio = true;
    packages = [
      pkgs.coppwr
      pkgs.discord
      pkgs.heroic
      pkgs.opencomposite
      pkgs.pwvucontrol
      pkgs.recordbox
    ];
    xmonad.enable = true;
  };

  programs.dconf.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_visual block
      set -g fish_cursor_external block
    '';
  };

  security.polkit.enable = true;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.acpid.enable = true;
  services.dbus.enable = true;

  users.users."xand" = {
    extraGroups = [
      "audio"
      "docker"
      "media"
      "music"
      "networkmanager"
      "render"
      "seat"
      "video"
    ];
  };

  users.users."gaming" = {
    extraGroups = [
      "audio"
      "media"
      "music"
      "render"
      "video"
    ];
  };

  users.groups."media" = {};
  users.groups."music" = {};

  users.users."music" = {
    enable = true;
    group = "music";
    extraGroups = [
      "audio"
      "media"
      "music"
    ];
    isNormalUser = false;
    isSystemUser = true;
  };

  virtualisation.docker.enable = true;

  # See https://nixos.org/nixos/options.html.
  system.stateVersion = "20.09";
}
