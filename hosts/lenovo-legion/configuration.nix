{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    ./display.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./nixpkgs.nix

    ../../sw/steam
    ../../sw/vim
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
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.prime = {
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:02:00:0";
  };

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

  services.acpid.enable = true;
  services.dbus.enable = true;
  services.xserver.verbose = 7;

  # See https://nixos.org/nixos/options.html.
  system.stateVersion = "20.09";
}
