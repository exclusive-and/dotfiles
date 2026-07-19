{
  buildNixosPackages
}:

let
  inherit (buildNixosPackages) callNixosConfiguration;
in
{
  nixosConfigurations.lenovo-legion = callNixosConfiguration ./nixos-configuration.nix {};
}
