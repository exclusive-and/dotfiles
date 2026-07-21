{ config, lib, pkgs, ... }:

{
  # Kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_1;
  boot.kernelParams = [
    "acpi_backlight=vendor"
    "mem_sleep_default=deep"
    "nvidia-drm.fbdev=1"
    "nvidia-drm.modeset=1"
  ];

  # Kernel: init RAM disk
  boot.initrd.systemd.enable = true;
  
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
  boot.blacklistedKernelModules = ["snd_soc_avs"];
  boot.kernelModules = [ ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  # Kernel: computer hostname
  networking.hostName = "lenovo-legion";
}
