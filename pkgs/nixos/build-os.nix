{
  inputs
, lib

  # List of paths to `nixosConfigurations` definitions. These target
  # configurations will be made available to build.
  #
  # For example:
  #
  # ```
  # targets = [ ./hosts/hyperion ./hosts/lenovo-legion ];
  # ```
, targets

  # The evaluator for the NixOS configuration modules. This should almost
  # always be one of the following:
  #
  #   * `inputs.nixpkgs.lib.nixosSystem`;
  #
  #   * `import "${nixpkgs}/nixos/lib/eval-config.nix"`.
, nixosSystem

, ...
}@args:

let

  buildNixosPackages = import ./make-package-set.nix {
    inherit inputs;
    inherit lib;
    inherit nixosSystem;
  };

  #
  # Build a single target NixOS configuration.
  #
  buildNixosTarget =
    target:
    let
      argsToStrip = [
        "inputs"
        "lib"
        "nixosSystem"
        "targets"
      ];

      f = import target;

      finalArgs =
        lib.intersectAttrs
          (lib.functionArgs f)
          (lib.removeAttrs args argsToStrip);
    in
      f (finalArgs // { inherit buildNixosPackages; });

in
  lib.foldl'
    lib.recursiveUpdate
    {}
    (lib.map buildNixosTarget args.targets)
