{ lib
, nixosSystem

, keys
, secrets

, home-manager
, nix-auth
, nix-monitored
, nurpkgs
, origami
, ragenix
}:

nixosSystem {
  modules = [
    home-manager.nixosModules.default
    nix-monitored.nixosModules.default
    origami
    ragenix.nixosModules.default
    {
      age.identityPaths = keys.private;
      age.secrets = (import secrets { inherit lib; }).hyperion;
    }
    {
      home-manager.extraSpecialArgs = {
        inherit nurpkgs;
      };
    }
    {
      nixpkgs.overlays = [
        (final: prev: {
          nix-auth = nix-auth.packages.${final.stdenv.hostPlatform.system}.default;
        })
      ];
    }
    ./configuration.nix
  ];
}
