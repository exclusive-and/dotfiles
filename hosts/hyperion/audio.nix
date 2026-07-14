{ lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  
  services.pipewire.enable = true;

  services.pipewire.package = pkgs.pipewire.overrideAttrs {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "pipewire";
      tag = "1.6.7";
      hash = "sha256-DSW9ho+NLikW/stlxvHLhRguMZy/4b7VEcC938ObJmQ=";
    };
    version = "1.6.7";
  };

  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = lib.mkForce false;
  services.pipewire.audio.enable = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.wireplumber.enable = true;

  services.pipewire.extraConfig.pipewire."10-clock-rates" = {
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
}
