{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./display.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./nixpkgs.nix
    ./power.nix

    ../../modules/nixos/alacritty.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/graphical/picom.nix
    ../../modules/nixos/graphical/rofi.nix
    ../../modules/nixos/graphical/xmonad-session.nix
    ../../modules/nixos/greet.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/users.nix
  ];

  environment.systemPackages = [
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

  hardware.graphics.enable = true;

  hardware.intel-gpu-tools.enable = true;

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.prime = {
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:02:00:0";
  };

  home-manager.useGlobalPkgs = true;

  home-manager.users."xand" = {
    imports = [
      ./xand.nix
    ];
  };

  networking.networkmanager.enable = true;

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

  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  services.dbus.enable = true;
  services.xserver.verbose = 7;

  # See https://nixos.org/nixos/options.html.
  system.stateVersion = "20.09";
}
