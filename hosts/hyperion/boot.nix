{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_1;
  boot.kernelParams = [];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };

  console.enable = true;
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  networking.hostName = "hyperion";
}
