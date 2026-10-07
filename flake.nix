{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-auth = {
      url = "github:numtide/nix-auth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-monitored.url = "github:ners/nix-monitored";

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.agenix.follows = "agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
  {
    agenix
  , home-manager
  , nix-auth
  , nix-monitored
  , nixos-hardware
  , nixpkgs
  , nixpkgs-unstable
  , nurpkgs
  , ragenix
  , self
  }@inputs:
  let
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in
  {
    nixosConfigurations.rica = nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              nix-auth = nix-auth.packages.${final.stdenv.hostPlatform.system}.default;
            })
          ];
        }
        nix-monitored.nixosModules.default
        ragenix.nixosModules.default
        ./hosts/rica/configuration.nix
      ];
      system = "x86_64-linux";
    };
    
    nixosConfigurations.hyperion = nixosSystem {
      modules = [
        home-manager.nixosModules.default
        {
          nixpkgs.overlays = [
            (final: prev: {
              nix-auth = nix-auth.packages.${final.stdenv.hostPlatform.system}.default;
            })
            nurpkgs.overlays.default
          ];
        }
        nix-monitored.nixosModules.default
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ragenix.nixosModules.default
        ./hosts/hyperion/configuration.nix
      ];
    };
  };
}
