let
  getFlake = import ../build-support/get-flake.nix;
in

{
  inputs
, lib
, nixosSystem
}:

lib.fix (
  final:
  {
    inherit lib;

    inherit (inputs)
      home-manager
      nix-auth
      nix-monitored
      nixos-hardware
      nurpkgs
      ragenix;
    
    inherit nixosSystem;

    callNixosConfiguration = lib.callPackageWith final;
  }
)
