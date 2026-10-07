{ config, lib, pkgs, ... }:

{
  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      ips = ["10.0.0.131/32" "fd00:c7::83/128"];
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
      privateKeyFile = config.age.secrets."key_wg0".path;
    };
  };

  networking.hostName = "lenovo-legion";

  networking.networkmanager = {
    enable = true;
    unmanaged = [ "wg0" ];
  };

  users.groups."networkmanager".members = [ "xand" ];
}
