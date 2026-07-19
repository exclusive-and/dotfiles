{
  config
, lib
, pkgs
, ...
}:
let
  cfg = config.origami.alacritty;
in
{
  options.origami = {
    alacritty = {
      enable = lib.mkOption {
        description = "Whether to enable Alacritty terminal emulator.";
        type = lib.types.bool;
        default = config.origami.xmonad.enable;
        example = true;
      };

      rofi = lib.mkOption {
        description = "Whether to make Alacritty the terminal for Rofi.";
        type = lib.types.bool;
        default = cfg.enable && config.origami.rofi.enable;
        example = true;
      };

      shell = lib.mkOption {
        description = "The shell interpreter that Alacritty should use.";
        type = lib.types.str;
        default = "${pkgs.fish}/bin/fish";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        # Install Alacritty to use as the default terminal emulator.
        programs.alacritty.enable = true;

        programs.alacritty.settings = {
          colors.primary = {
            background = "#040404";
            foreground = "#a7f4c1";
          };
          keyboard.bindings = [
            { key = "C"; mods = "Control | Shift"; action = "Copy"; }
            { key = "V"; mods = "Control | Shift"; action = "Paste"; }
          ];
          terminal.shell = cfg.shell;
          window.decorations = "full";
          window.opacity = 0.85;
          window.padding.x = 10;
          window.padding.y = 10;
        };
      }
    ];
  };
}
