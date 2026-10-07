{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./networking.nix
    ./nixpkgs.nix
    ./nspawn-image.nix
    (modulesPath + "/profiles/minimal.nix")
  ];

  age.identityPaths = [
    "/root/.ssh/id_ed25519"
  ];

  age.secrets = {
    "wireguard.privatekey".file = ./secrets/wireguard.privatekey.age;
  };

  # Set timezone to Montreal. Appears to be broken in systemd-nspawn
  # containers.
  time.timeZone = "America/Montreal";

  # Install some software tools. These tools are to provide general system
  # functionality and basic other basic utilities.
  environment.systemPackages = [
    pkgs.curl
    pkgs.git
    pkgs.lshw
    pkgs.niv
    pkgs.rsync
    pkgs.vim
    pkgs.wget
  ];

  # Activate VTY.
  console.enable = true;
  console.font = null;
  console.colors = [];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_visual block
      set -g fish_cursor_external block
    '';
  };

  system.stateVersion = "25.11";
}
