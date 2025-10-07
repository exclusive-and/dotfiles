{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    
    profiles = {
      default = {
        id = 0;
        extensions = {
          packages = with pkgs.firefox-addons; [
            dashlane
            toggl-button-time-tracker
            ublock-origin
          ];
        };
        path = "2d43dm8x.default";
        settings = {
            "browser.tabs.closeTabByDblclick" = true;
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
        };
      };
    };
  };
}
