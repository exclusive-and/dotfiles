{
  config
, lib
, pkgs
, ...
}:
let
  cfg = config.origami.picom;
in
{
  options.origami = {
    picom = {
      enable = lib.mkOption {
        description = "Whether to enable the Picom compositor.";
        type = lib.types.bool;
        default = config.origami.xmonad.enable;
        example = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.picom.enable = true;

    # Make sure to use the GLX backend as that one seems to be the least broken.
    services.picom.backend = "glx";

    services.picom.activeOpacity = 1.00;
    services.picom.inactiveOpacity = 1.00;
    services.picom.fade = true;
    services.picom.fadeDelta = 2;

    # Enable VSync to prevent screen tearing.
    services.picom.vSync = true;
    
    services.picom.settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
      blur-background-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
        "class_g = 'Rofi'"
        "window_type = 'desktop'"
        "window_type = 'menu'"
        "window_type = 'tooltip'"
        "window_type = 'utility'"
      ];
      corner-radius = 5;
      detect-rounded-corners = true;
      experimental-backends = false;
      frame-pacing = false;
      opacity-rule = [
        "100:class_g = 'firefox'"
        "100:class_g = 'Rofi'"
        "100:window_type = 'menu'"
        "100:window_type = 'popup_menu'"
        "100:window_type = 'tooltip'"
      ];
      round-borders = 1;
      shadow-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
        "class_g = 'Rofi'"
        "window_type = 'desktop'"
        "window_type = 'menu'"
        "window_type = 'tooltip'"
        "window_type = 'utility'"
      ];
      unredir-if-possible = true;
    };
  };
}