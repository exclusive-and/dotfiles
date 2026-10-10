{ config, lib, pkgs, ... }:

{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";

    # No kernel command-line editor in the bootloader.
    editor = false;
  };

  # Kernel: stage 1 initramdisk
  boot.initrd = {
    availableKernelModules = [
      "nvme"
      "hid_generic"
      "usbhid"
      "xhci_hcd"
      "xhci_pci"
    ];
    compressor = "zstd";
    kernelModules = [ ];

    includeDefaultModules = false;

    enable = true;
    systemd.enable = true;
    systemd.dbus.enable = false;
  };

  boot.initrd.luks.devices = {
    "luks-rpool-nvme0n1p3".device = "/dev/nvme0n1p3";
  };

  # Kernel
  boot.kernelModules = [
    "k10temp"
    "nvme"
    "xhci_pci"
  ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_2;
  boot.kernelParams = [
    "driver_async_probe=*"
    "initcall_blacklist=tpm_tis_init"
    "modprobe.blacklist=tpm_tis,tpm_crb,tpm"
    "nvidia_drm.fbdev=1"
    "nvidia_drm.modeset=1"
    "nvme_core.default_ps_max_latency_us=0"
    "rootdelay=0"
    "8250.nr_uarts=0"
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # Kernel: initial console setup
  console.enable = true;
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    
    extraLocaleSettings = {
      LANG    = "en_CA.UTF-8";
      LC_TIME = "C";
    }; 

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_CA.UTF-8/UTF-8"
    ];
  };

  services.xserver.xkb.layout = "us";

  time.timeZone = "America/Montreal";
}
