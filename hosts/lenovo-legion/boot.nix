{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };

  boot.blacklistedKernelModules = ["snd_soc_avs"];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  console.enable = true;
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  networking.hostName = "lenovo-legion";
}
