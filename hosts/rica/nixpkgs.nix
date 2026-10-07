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
      "@wheel"
    ];
    warn-dirty = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-ld.enable = true;
}
