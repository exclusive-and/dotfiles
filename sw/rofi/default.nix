{ config, pkgs, ... }:

let
    inherit (config.home) homeDirectory;
in
{
    programs.rofi = {
        enable = true;
        plugins = with pkgs; [ rofi-emoji ];
        terminal = "${pkgs.alacritty}/bin/alacritty";
        theme = ./theme.rasi;
    };

    home.packages = [ pkgs.xdotool ];
}