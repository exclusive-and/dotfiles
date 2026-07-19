{ config, lib, pkgs, ... }:

let
  
  cfg = config.origami.xmonad;

  forEachUser = lib.genAttrs cfg.users;

in
{
  options.origami = {
    xmonad = {
      enable = lib.mkOption {
        description = "Whether to enable XMonad window manager.";
        type = lib.types.bool;
        default = false;
        example = true;
      };

      source = lib.mkOption {
        description = "The Haskell source file for XMonad to use.";
        type = lib.types.path;
        default = ./xmonad.hs;
      };

      users = lib.mkOption {
        description = ''

        '';
        type = with lib.types; listOf str;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # Make startx the login command for all XMonad users.
    origami.greet.logins =
      forEachUser
      (_: "${pkgs.xinit}/bin/startx");

    environment.systemPackages = [
      pkgs.xinit # X server initialization (xinit, startx)
    ];

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
    };

    home-manager.users = forEachUser (user: {
      # Manage this user's X session.
      xsession.enable = true;

      # Tell home-manager to put the user's X session script in ~/.xinitrc
      # so that startx is happy.
      xsession.scriptPath = ".xinitrc";

      xsession.windowManager.xmonad = {
        # Make XMonad the window manager for this session.
        enable = true;
        config = cfg.source;

        extraPackages =
          haskellPackages:
          let
            xmonadrc = haskellPackages.callPackage ./xmonadrc.nix {};
          in
          [
            haskellPackages.containers
            haskellPackages.data-default
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            xmonadrc
          ];
      };

      home.sessionVariables = {
        DISPLAY = ":0";
      };

      home.packages = with pkgs; [
        feh
        pywal
        xdotool
      ];

      xsession.initExtra = ''
        set +x
        ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
        ${pkgs.xset}/bin/xset s off
      '';
    });

  };
}
