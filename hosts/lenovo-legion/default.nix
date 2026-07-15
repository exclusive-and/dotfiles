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
  nixosConfigurations.lenovo-legion = callNixosConfiguration ./nixos-configuration.nix {
    inherit keys secrets origami;
  };
}
