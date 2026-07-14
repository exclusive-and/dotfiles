{
  ospkgs
, keys
, secrets
, origami
}:

let
  inherit (ospkgs) callNixosConfiguration;
in
{
  nixosConfigurations.hyperion = callNixosConfiguration ./nixos-configuration.nix {
    inherit keys secrets origami;
  };
}
