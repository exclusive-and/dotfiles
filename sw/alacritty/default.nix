{ config, pkgs, ... }:

let
    colors = {
        primary = {
            background = "#040404";
            foreground = "#c5c8c6";
        };
    };

    keyboard = {
        bindings = [
            { key = "C"; mods = "Control | Shift"; action = "Copy"; }
            { key = "V"; mods = "Control | Shift"; action = "Paste"; }
        ];
    };

    terminal = {
        shell = "${pkgs.fish}/bin/fish";
    };

    window = {
        decorations = "full";
        opacity = 0.85;
        padding = {
            x = 10;
            y = 10;
        };
    };
in
{
    programs.alacritty = {
        enable = true;
        settings = {
            inherit colors keyboard window terminal;
        };
    };
}