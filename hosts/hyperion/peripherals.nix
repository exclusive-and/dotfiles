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
  
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.91.07";
      sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
      sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
      openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
      settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
      persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
    };
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  services.xserver = {
    monitorSection = ''
      Option "DPMS" "false"
    '';

    screenSection = ''
      Option "metamodes" "3840x2160_240 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    '';
    
    serverLayoutSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
    '';

    verbose = 7;
    videoDrivers = [ "nvidia" ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME   = "nvidia";
    GBM_BACKEND         = "nvidia-drm";
    __GL_GSYNC_ALLOWED  = "1";
    __GL_VRR_ALLOWED    = "1";
    NVD_BACKEND         = "direct";
  };
}
