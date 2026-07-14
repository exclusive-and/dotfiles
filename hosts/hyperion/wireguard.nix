{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [pkgs.wireguard-tools];
  
  networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
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
}

