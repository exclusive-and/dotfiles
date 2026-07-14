{
  inputs
, lib
, nixosSystem
, targets
, ...
}@args:

let

  ospkgs = import ./bootstrap.nix {
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
      f (finalArgs // { inherit ospkgs; });

in
  lib.foldl'
    lib.recursiveUpdate
    {}
    (lib.map buildNixosTarget args.targets)
