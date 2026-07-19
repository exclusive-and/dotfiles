{ config, pkgs, ... }:

{
  programs.steam.enable = true;

  programs.steam.dedicatedServer.openFirewall = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.localNetworkGameTransfers.openFirewall = true;
}
