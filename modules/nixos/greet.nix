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

  # Create the user login script.
  loginScript = pkgs.writeTextFile {
    executable = true;
    name = "login.sh";
    text =
      let
        loginCmds = mapAttrsToList
          (name: cmd: "'${name}') ${cmd};;")
          cfg.logins;
      in
      ''
        #!/bin/sh
        case "''$(whoami)" in
        ${concatStringsSep "\n" (nest 2 loginCmds)}
        esac
      '';
  };
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

      logins = lib.mkOption {
        description = ''

        '';
        type = with lib.types; attrsOf path;
      };

      greetCommand = lib.mkOption {
        readOnly = true;
        type = lib.types.str;
        default = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --cmd /usr/shared/login.sh \
            --issue \
            --asterisks --asterisks-char "=" \
            --theme '${cfg.theme}'
        '';
      };

      initialUser = lib.mkOption {
        description = "The initial session user.";
        type = lib.types.str;
        default = "xand";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # Put the login script is in the system packages so that it gets linked to
    # /usr/shared/login[..].sh
    system.activationScripts = {
      loginScript = {
        deps = [];
        text = ''
          mkdir -p /usr/shared
          ln -sfn ${loginScript} /usr/shared/login.sh
        '';
      };
    };

    services.greetd.enable = true;
    services.seatd.enable = true;

    services.greetd.settings = {
      default_session = {
        command = cfg.greetCommand;
        user = "greeter";
      };

      # Auto-login session; happens once on initial startup.
      initial_session = {
        command = cfg.logins.${cfg.initialUser};
        user = cfg.initialUser;
      };
    };

    services.greetd.useTextGreeter = true;

    environment.etc."issue".text = cfg.message;

  };
}
