{
  inputs
, lib
, nixosSystem
}:

let

  getFlake = import ../build-support/get-flake.nix;

  /*
  inputs = getFlake {
    src = ../../inputs;
    copySourceTreeToStore = false;
  };
  */

  bootstrapNixosPackages = final: prev: {
    inherit nixosSystem;
    inherit (inputs) home-manager nix-auth nix-monitored nurpkgs ragenix;
  };

  splice =
    final: prev: import ./splice.nix lib final;

  bootstrapNixosStages = [
    bootstrapNixosPackages
    splice
  ];

in

lib.fix (lib.foldl' (lib.flip lib.extends) (_: {}) bootstrapNixosStages)
