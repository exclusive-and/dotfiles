args@{
  sources
, lib
, nixosSystem
, origami
}:
let

  concat' = lib.foldl' (b: a: a ++ b) [];

in
{
  nixosConfigurations."lemur-pro" = nixosSystem {
    modules = concat' [
      [origami]
      [
        ./configuration.nix
        
      ]
      [
        "${sources.agenix}/modules/age.nix"
        "${sources.home-manager}/nixos"
      ]
    ];

    specialArgs = {
      inherit (sources) nurpkgs;
    };
  };
}
