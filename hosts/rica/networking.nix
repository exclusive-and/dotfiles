{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.wireguard-tools
  ];

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      listenPort = 51820;
      privateKeyFile = config.age.secrets."wireguard.privatekey".path;
      ips = [
        "10.0.0.1/32"
        "fd00:c7::1/128"
      ];
      peers = [
        {
          name = "rica-host";
          publicKey = "N+iGIj4Oj/zXqJmAm03TJVflE4JTMqt1fmv5aDr1vw4=";
          allowedIPs = [
            "10.0.0.100/32"
          ];
          endpoint = "192.100.100.1:51821";
          dynamicEndpointRefreshSeconds = 30;
        }
        {
          name = "hyperion";
          publicKey = "G+ah0rvNoEWElJgOm7WZh03y3imFMKZorEx5ZwvOnkI=";
          allowedIPs = [
            "10.0.0.17/32"
            "fd00:c7::11/128"
          ];
          dynamicEndpointRefreshSeconds = 30;
        }
        {
          name = "lenovo-laptop";
          publicKey = "anPGbYe/qz6smn3pd9IRGJELixeh5/E8Cb8eZ+6+VwY=";
          allowedIPs = [
            "10.0.0.131/32"
            "fd00:c7::83/128"
          ];
        }
        {
          name = "system76-laptop";
          publicKey = "THSWE1ZS1U5rbCwpP+OvzgYaNaq22Z8IL7pPOfFYOEs=";
          allowedIPs = [
            "10.0.0.3/32"
          ];
        }
        {
          name = "pixel8";
          publicKey = "nlU/TpMONoiTaDEJa1mOmZIWKbjtnWHGV6O/ZG4kTSA=";
          allowedIPs = [
            "10.0.0.241"
          ];
        }
      ];
    };
  };

  networking.networkmanager = {
    enable = true;
    unmanaged = [ "wg0" ];
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
        addr = "10.0.0.1";
        port = 22;
      }
      {
        addr = "fd00:c7::1";
        port = 22;
      }
    ];
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = false;
  };

  networking.hostName = "rica-nixos";
}
