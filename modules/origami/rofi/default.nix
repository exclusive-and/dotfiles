{
  config
, lib
, pkgs
, ...
}:
let
  cfg = config.origami.rofi;
  forEachUser = lib.genAttrs config.origami.xmonad.users;
in
{
  options.origami = {
    rofi = {
      enable = lib.mkOption {
        description = "Whether to enable the Rofi app launcher.";
        type = lib.types.bool;
        default = config.origami.xmonad.enable;
        example = true;
      };

      theme = lib.mkOption {
        description = "Choose the Rofi launcher's visual theme.";
        type = with lib.types; either str path;
        default = ./theme.rasi;
      };

      terminal = lib.mkOption {
        description = "The terminal Rofi will use to execute commands.";
        type = lib.types.str;
        default = "${pkgs.alacritty}/bin/alacritty";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = forEachUser (_: {
      # Enable Rofi application launcher.
      programs.rofi.enable = true;

      programs.rofi.plugins = with pkgs; [
        rofi-emoji
      ];

      programs.rofi.theme = cfg.theme;
      programs.rofi.terminal = cfg.terminal;
    });
  };
}
