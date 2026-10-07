{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
