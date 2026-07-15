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
  nixosConfigurations.lenovo-legion = callNixosConfiguration ./nixos-configuration.nix {
    inherit keys secrets origami;
  };
}
