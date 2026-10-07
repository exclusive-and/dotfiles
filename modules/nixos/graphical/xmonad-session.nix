{ config, lib, pkgs, ... }:

let
  cfg = config.origami.xmonad;

  forEachUser = lib.genAttrs cfg.users;

  ghcWithPackages = cfg.haskellPackages.ghcWithPackages;

  xmonadrc = ghcWithPackages (
    haskellPackages: [
      haskellPackages.xmonad
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      (haskellPackages.callPackage ./xmonadrc.nix {})
    ]
  );

  xmonad-command = pkgs.runCommand "xmonad"
    {
      preferLocalBuild = true;
      nativeBuildInputs = [ pkgs.makeWrapper ];
    }
    ''
      install -D ${xmonadrc}/share/man/man1/xmonad.1.gz $out/share/man/man1/xmonad.1.gz
      makeWrapper ${xmonadrc}/bin/xmonadrc $out/bin/xmonad \
        `# --set XMONAD_GHC "${xmonadrc}/bin/ghc"` \
        --set XMONAD_XMESSAGE "${pkgs.xmessage}/bin/xmessage"
    '';
  
  xmonad-session-script = pkgs.writeScript "xsession" ''
    #! ${pkgs.bash}/bin/bash
    systemd-cat -t xmonad -- ${xmonad-command}/bin/xmonad &
    waitPID=$!
    systemctl --user import-environment XDG_SESSION_TYPE DISPLAY XAUTHORITY
    systemctl --user start picom
    test -n "$waitPID" && wait "$waitPID"
    systemctl --user stop graphical-session.target
    exit 0
  '';

  xmonad-session-desktop = pkgs.writeTextFile {
    name = "none+xmonad";
    destination = "/share/xsessions/none+xmonad.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Name=none+xmonad
      DesktopNames=none+xmonad
      Type=XSession
      Exec=${xmonad-session-script}
      TryExec=${xmonad-session-script}
    '';
  };

  xmonad-session-pkg = xmonad-session-desktop // {
    providedSessions = [
      "none+xmonad"
    ];
  };
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

      haskellPackages = lib.mkOption {
        default = pkgs.haskellPackages;
        type = lib.types.attrs;
      };

      source = lib.mkOption {
        description = "The Haskell source file for XMonad to use.";
        type = lib.types.path;
        default = ./xmonad.hs;
      };

      xinitrc = lib.mkOption {
        default = xmonad-session-script;
        readOnly = true;
        type = with lib.types; oneOf [ str path package ];
      };

      xsession = lib.mkOption {
        default = xmonad-session-pkg;
        readOnly = true;
        type = with lib.types; oneOf [ str path package ];
      };

      users = lib.mkOption {
        description = ''

        '';
        type = with lib.types; listOf str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.feh
      xmonad-command
    ];

    services = {
      displayManager.enable = true;
      displayManager.sessionPackages = [ xmonad-session-pkg ];

      xserver.enable = true;
      xserver.displayManager.startx.enable = true;
    };
  };
}
