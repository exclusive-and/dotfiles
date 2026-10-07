{
  config
, lib
, pkgs
, ...
}:
let
  cfg = config.origami.greet;

  inherit (lib)
    concat
    concatMap
    concatMapStrings
    concatStringsSep
    foldl
    imap0
    map
    mapAttrsToList
    range;

  hang = n:
    let
      indent = concatMapStrings (_: " ") (range 1 n);
    in imap0 (i: x: if i == 0 then x else indent + x);

  nest = n:
    let
      indent = concatMapStrings (_: " ") (range 1 n);
    in map (x: indent + x);

  # Grab some system information. We'll need these in a couple places.
  inherit (config.networking) hostName;
  inherit (config.system.nixos) codeName distroName version;

  sessionPath = config.services.displayManager.sessionData.desktops;
in
{
  options.origami = {
    greet = {
      enable = lib.mkOption {
        description = "Whether to enable greetd and tuigreet.";
        default = true;
        example = false;
        type = lib.types.bool;
      };

      message = lib.mkOption {
        description = "The message that the greeter should display.";
        type = lib.types.str;
        default = ''
          ${distroName} ${codeName} ${version}
          -
          ${hostName}
        '';
      };

      theme = lib.mkOption {
        description = "The tuigreet theme to use.";
        type = lib.types.str;
        default = "border=black;container=red;greet=white;prompt=white;input=black;button=yellow;action=red";
      };

      greetCommand = lib.mkOption {
        readOnly = true;
        type = lib.types.str;
        default = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --issue \
            --asterisks --asterisks-char "=" \
            --theme '${cfg.theme}' \
            --remember \
            --remember-user-session \
            --sessions "${sessionPath}/share/wayland-sessions" \
            --xsessions "${sessionPath}/share/xsessions"
        '';
      };

      autoLogin = lib.mkOption {
        type = lib.types.submodule {
          options.user = lib.mkOption {
            type = lib.types.str;
            default = "xand";
          };

          options.command = lib.mkOption {
            type = lib.types.str; 
            default = "startx ${config.origami.xmonad.xinitrc}";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."issue".text = cfg.message;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = cfg.greetCommand;
          user = "greeter";
        };
        # Auto-login session; happens once on initial startup.
        initial_session = {
          command = "${cfg.autoLogin.command}";
          user = "${cfg.autoLogin.user}";
        };
      };
      useTextGreeter = true;
    };

    systemd.services.greetd = {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = lib.mkForce "null";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };

    services.seatd.enable = true;
  };
}
