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

    # Manage this user's X session.
    xsession.enable = true;

    # Tell home-manager to put the user's X session script in ~/.xinitrc
    # so that we make startx happy.
    xsession.scriptPath = ".xinitrc";

    xsession.windowManager.xmonad = {
      config = ./main/xmonad.hs;
      enable = true;
      extraPackages = haskellPackages: [
        haskellPackages.containers
        haskellPackages.dbus
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };

    xsession.initExtra = ''
      set +x
      ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
      ${pkgs.xorg.xset}/bin/xset s off
    '';
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
