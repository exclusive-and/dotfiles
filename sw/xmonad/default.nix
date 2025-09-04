let
    xmonad = {
        config = ./main/xmonad.hs;
        enable = true;
        extraPackages = haskellPackages: [
            haskellPackages.containers
            haskellPackages.dbus
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
        ];
    };
in
{
    homeModules.default = {config, pkgs, ...}:
    {
        imports = [
            ../alacritty
            ../rofi
            ../picom
            ../unclutter
        ];
        
        home.packages = with pkgs; [
            feh
            pywal
        ];
    
        home.sessionVariables = {
            DISPLAY = ":0";
        };

        xsession.enable = true;
        xsession.initExtra = ''
            set +x
            ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
            ${pkgs.xorg.xset}/bin/xset s off
        '';
        xsession.scriptPath = ".xinitrc";
        xsession.windowManager.xmonad = xmonad;
    };

    nixosModules.default = {config, pkgs, ...}:
    {
        environment.systemPackages = with pkgs; [
            xorg.xinit # X server initialization (xinit, startx)
        ];

        services.xserver = {
            enable = true;
            displayManager.startx.enable = true;
        };
    };
}
