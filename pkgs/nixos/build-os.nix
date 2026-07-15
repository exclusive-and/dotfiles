{
  inputs
, lib
, nixosSystem
, targets
, ...
}@args:

let

  buildNixosPackages = import ./make-package-set.nix {
    inherit inputs lib nixosSystem;
  };

  #
  # Build a single target NixOS configuration.
  #
  buildNixosTarget =
    target:
    let
      f = import target;

      finalArgs =
        lib.intersectAttrs
          (lib.functionArgs f)
          (lib.removeAttrs args ["targets"]);
    in
      f (finalArgs // { inherit buildNixosPackages; });

in
  lib.foldl'
    lib.recursiveUpdate
    {}
    (lib.map buildNixosTarget args.targets)
