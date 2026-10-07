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

  networking.hostName = "hyperion";
  networking.nameservers = [ "1.1.1.1" "4.4.4.4" "192.168.2.1" ];

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];

  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      ips = ["10.0.0.17/32" "fd00:c7::11/128"];
      listenPort = 51280;
      peers = [
        {
          allowedIPs = ["10.0.0.0/24" "fd00:c7::/64"];
          name = "rica-nixos";
          publicKey = "5Tx4KvYAqObXgIdOERMsZz5OTIFRaOkUiB3NVgXN4ks=";
          endpoint = "38.49.217.58:51820";
          persistentKeepalive = 20;
          dynamicEndpointRefreshSeconds = 20;
        }
      ];
      privateKeyFile = config.age.secrets."wireguard.privatekey".path;
    };
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

  networking.networkmanager = {
    enable = true;
    unmanaged = [ "wg0" ];
  };

  users.extraGroups."networkmanager".members = [ "xand" ];
}
