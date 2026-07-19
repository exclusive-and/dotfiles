{
  nixosSystem
, lib

, home-manager
, nix-auth
, nix-monitored
, nixos-hardware
, nurpkgs
, ragenix
}:

nixosSystem {
  modules = [
    # Add some packages to `nixpkgs`.
    {
      nixpkgs.overlays = [
        nurpkgs.overlays.default

        (final: prev: {
          nix-auth = nix-auth.packages.${final.stdenv.hostPlatform.system}.default;
        })
      ];
    }

    # Install `home-manager`.
    home-manager.nixosModules.default

    # Security: install `ragenix` for secret management.
    ragenix.nixosModules.default

    # Hardware
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.lenovo-legion-16iax10h

    ./configuration.nix

    # NOM: replace stock Nix executables with `nix-monitored`.
    nix-monitored.nixosModules.default
  ];
}
