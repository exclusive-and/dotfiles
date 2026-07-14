{
  config
, lib
, pkgs
, ...
}:
let
  cfg = config.origami.audio;
in
{
  options.origami = {
    audio = {
      enable = lib.mkOption {
        description = "Whether to enable pipewire-based audio.";
        type = lib.types.bool;
        default = false;
        example = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire.enable = true;

    # Enable rtkit so that pipewire can get real-time priority.
    security.rtkit.enable = true;

    services.pipewire.alsa.enable = true;
    services.pipewire.audio.enable = true;
    services.pipewire.jack.enable = true;
    services.pipewire.pulse.enable = true;
    services.pipewire.wireplumber.enable = true;
    
    services.pipewire.extraConfig = {
      pipewire."10-clock-rates" = {
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
    };
  };
}
