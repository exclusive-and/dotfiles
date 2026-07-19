{
  config
, lib
, pkgs
, sources
, ...
}:
let

  concat' = lib.foldl' (b: a: a ++ b) [];

  cfg = config.origami;

  forEachUser = f: lib.mapAttrs f cfg.users;

  userOptions = {

    options.audio = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to add this user to the 'audio' group.
      '';
    };

    options.packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
    };

    options.picom = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.origami.xmonad.enable;
        example = true;
        description = ''
          Whether to enable the Picom compositor.
        '';
      };
    };

    options.shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fish;
    };

    options.xmonad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable XMonad window manager.
        '';
      };
    };

    options.wheel = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to add this user to the 'wheel' group.
      '';
    };
    
  };

in
{
  options.origami = {
    users = lib.mkOption {
      type = with lib.types; attrsOf (submodule userOptions);
    };
  };

  config = {
    users.users = forEachUser (
      username: usercfg:
      {
        isNormalUser = true;
        extraGroups = concat' [
          (if usercfg.audio then ["audio"] else [])
          (if usercfg.wheel then ["wheel"] else [])
        ];
        inherit (usercfg) packages;
        inherit (usercfg) shell;
      }
    );

    origami.xmonad.users = concat' (
      lib.mapAttrsToList
        (username: usercfg: if usercfg.xmonad.enable then [username] else [])
        cfg.users
    );
  };
}
