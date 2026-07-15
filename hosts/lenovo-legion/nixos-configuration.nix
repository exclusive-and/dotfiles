{ lib
, nixosSystem

, keys
, secrets

, home-manager
, nix-auth
, nix-monitored
, nixos-hardware
, nurpkgs
, origami
, ragenix
}:

nixosSystem {
  modules = [
    home-manager.nixosModules.default
    nix-monitored.nixosModules.default
    nixos-hardware.nixosModules.lenovo-legion-16iax10h
    origami
    ragenix.nixosModules.default
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
