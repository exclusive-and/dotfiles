{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = lib.mkForce false;
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

    extraConfig.pipewire."10-clock-rates" = {
      "context.properties" = {
        "audio.format" = "s32le";
        # "default.clock.rate" = 192000;
        # "default.clock.allowed-rates" = [
        #     192000
        #     96000
        #     48000
        #     44100
        # ];
      };
    };

    package = pkgs.pipewire.overrideAttrs {
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "pipewire";
        tag = "1.6.7";
        hash = "sha256-DSW9ho+NLikW/stlxvHLhRguMZy/4b7VEcC938ObJmQ=";
      };
      version = "1.6.7";
    };
  };

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  hardware.intel-gpu-tools.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    prime = {
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:02:00:0";
    };
  };

  services.xserver = {
    monitorSection = ''
      Option "DPMS" "false"
    '';

    screenSection = ''
      Option "metamodes" "2560x1600_165 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    '';

    serverLayoutSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
    '';

    verbose = 7;
  };
}
