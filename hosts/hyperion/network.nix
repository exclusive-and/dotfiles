{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      22  # ssh
      80  # http
      443 # https
    ];
  };
  
  networking.hosts = {
    "127.0.0.1" = [
      "computeroid.org"
      "coraless.computeroid.org"
      "git.computeroid.org"
      "xandgate.com"
      "git.xandgate.com"
    ];
  };

  services.ddclient = {
    enable = true;
    configFile = "/etc/ddclient/ddclient.conf";
  };

  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    listenAddresses = [
      # Allow internal connections via loopback interface.
      {
        addr = "127.0.0.1";
        port = 22;
      }

      # Allow connections via the Wireguard VPN on interface wg0.
      {
        addr = "10.0.0.17";
        port = 22;
      }
      {
        addr = "fd00:c7::11";
        port = 22;
      }
    ];
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  networking.hostName = "hyperion";
  
  networking.nameservers = [
    "1.1.1.1"
    "4.4.4.4"
    "192.168.2.1"
  ];

  networking.networkmanager = {
    enable = true;
    unmanaged = [ "wg0" ];
  };

  users.extraGroups = {
    "networkmanager".members = [ "xand" ];
  };
}
