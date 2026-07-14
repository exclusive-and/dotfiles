{
  lib
, ...
}:
let
  #
  # Default secrets that are shared by all systems.
  #
  defaultSecrets = {};

  #
  # Per-system secrets.
  #
  secrets = {
    hyperion = {
      "wireguard.privatekey" = {
        file = ./hyperion/wireguard.privatekey.age;
      };
    };
  };
in
  lib.mapAttrs (_: x: x // defaultSecrets) secrets
