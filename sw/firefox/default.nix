{ config, pkgs, ... }:

let
    extensions = with pkgs.firefox-addons; [
        dashlane
        toggl-button-time-tracker
        ublock-origin
    ];

    settings = {
        "browser.tabs.closeTabByDblclick" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
    };
in
{
    programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        profiles = {
            default = {
                id = 0;
                path = "2d43dm8x.default";
                inherit extensions settings;
            };
        };
    };
}