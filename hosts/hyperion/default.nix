{
  buildNixosPackages
}:

let
  inherit (buildNixosPackages) callNixosConfiguration;
in
{
  nixosConfigurations.hyperion = callNixosConfiguration ./nixos-configuration.nix {};
}
