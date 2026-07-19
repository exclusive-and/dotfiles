{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.curl
    pkgs.git
    pkgs.niv
    pkgs.nix-auth
    pkgs.nix-output-monitor
    pkgs.wget
  ];

  environment.variables.NIX_REMOTE = "daemon";

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";

  nix.monitored.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nix.settings.trusted-users = [
    "root"
    "xand"
    "@wheel"
  ];

  nix.settings.warn-dirty = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.input-fonts.acceptLicense = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
  
  nixpkgs.overlays = [
    (final: prev: {
      #openblas = prev.openblas.overrideAttrs {
      #  doCheck = false;
      #};
      vim = prev.callPackage ../../pkgs/vim/vimrc.nix {};
    })
  ];

  programs.nix-ld.enable = true;
}
