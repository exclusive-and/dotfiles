{
  buildNixosPackages
, keys
, secrets
, origami
}:

let
  inherit (buildNixosPackages) callNixosConfiguration;
in
{
  nixosConfigurations.hyperion = callNixosConfiguration ./nixos-configuration.nix {
    inherit keys secrets origami;
  };
}
