{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./display.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./network.nix
    ./nixpkgs.nix
    ./wireguard.nix

    ../../sw/forgejo
    ../../sw/monado
    ../../sw/nginx
    ../../sw/slack
    ../../sw/steam
    ../../sw/vim
    ../../webhosts/coraless
  ];

  environment.systemPackages = [
    pkgs.acpi
    pkgs.btop
    pkgs.lshw
    pkgs.ragenix
    pkgs.rsync
    pkgs.unzip
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

  hardware.graphics.enable = true;

  hardware.nvidia.modesetting.enable = false;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;

#  home-manager.useGlobalPkgs = true;
#  home-manager.useUserPackages = true;

  home-manager.users."xand" = {
    imports = [
      ./xand.nix
    ];
  };

  home-manager.users."gaming" = {
    imports = [
      ./gaming.nix
    ];
  };

  origami.audio.enable = true;
  origami.greet.enable = true;
  origami.rofi.enable = true;
  origami.xmonad.enable = true;
  origami.xmonad.users = ["xand"];

  origami.users."xand".audio = true;
  origami.users."xand".packages = [
    pkgs.bitwarden-desktop
    pkgs.coppwr
    pkgs.pwvucontrol
    pkgs.recordbox
  ];
  origami.users."xand".wheel = true;
  origami.users."xand".xmonad.enable = true;

  origami.users."gaming".audio = true;
  origami.users."gaming".packages = [
    pkgs.coppwr
    pkgs.discord
    pkgs.heroic
    pkgs.opencomposite
    pkgs.pwvucontrol
    pkgs.recordbox
  ];
  origami.users."gaming".xmonad.enable = true;

  programs.dconf.enable = true;
  programs.fish.enable = true;

  security.polkit.enable = true;

  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  services.acpid.enable = true;
  services.dbus.enable = true;
  services.xserver.verbose = 7;
  services.xserver.videoDrivers = [ "nvidia" ];

  # See https://nixos.org/nixos/options.html.
  system.stateVersion = "20.09";
}
