{ config, lib, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_1;
  boot.kernelParams = [];
  
  # Bootloader: systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };

  console.enable = true;
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Kernel: kernel modules
  boot.kernelModules = [ ];

  # Kernel: computer hostname
  networking.hostName = "hyperion";
}
