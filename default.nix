let
  sources = import ./nix/sources.nix;
in
{
  system ? builtins.currentSystem,
  
  ragenix ? null,
  nixpkgs ? sources.nixpkgs,
  nurpkgs ? sources.nurpkgs,
  home-manager ? sources.home-manager,
  ...
}:
let
  nixosSystem = args:
    if nixpkgs ? lib then
      nixpkgs.lib.nixosSystem args
    else
      import "${nixpkgs}/nixos/lib/eval-config.nix" args;

  pkgs = import nixpkgs {
    config.allowBroken = false;
    config.allowUnfree = true;

    config.input-fonts.acceptLicense = true;

    inherit system;

    overlays = import ./overlays.nix {
      inherit nurpkgs;
    };
  };

  homeManager = import home-manager {
    inherit pkgs;
  };

  inherit (homeManager.lib) homeManagerConfiguration;

  hyperion = import ./hyperion;
  users = import ./users;
  xmonad = import ./sw/xmonad;
in
{
  homeConfigurations.xand = homeManagerConfiguration {
    inherit pkgs;

    modules = with users; [
      xand.homeModules.default
      xmonad.homeModules.default
    ];
  };

  homeConfigurations.gaming = homeManagerConfiguration {
    inherit pkgs;

    modules = with users; [
      gaming.homeModules.default
      gaming.homeModules.vr
      xmonad.homeModules.default
    ];
  };

  nixosConfigurations.hyperion = nixosSystem {
    inherit pkgs;

    modules = with users; [
      ragenix.nixosModules.default
      gaming.nixosModules.default
      hyperion.nixosModules.default
      xand.nixosModules.default
      xmonad.nixosModules.default
    ];
  };
}
