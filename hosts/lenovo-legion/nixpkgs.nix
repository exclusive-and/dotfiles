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

  environment.variables = {
    NIX_REMOTE = "daemon";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.monitored.enable = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    trusted-users = [
      "root"
      "xand"
      "@wheel"
    ];
    warn-dirty = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };
  
  nixpkgs.overlays = [
    (final: prev: {
      #openblas = prev.openblas.overrideAttrs {
      #  doCheck = false;
      #};
      custom-slack = prev.callPackage ../../pkgs/slack/slack.nix {};
      custom-vimrc = prev.callPackage ../../pkgs/vim/vimrc.nix {};
    })
  ];

  programs.nix-ld.enable = true;
}
