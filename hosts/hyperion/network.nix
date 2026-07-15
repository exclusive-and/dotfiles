{
  # Ethernet
  networking.interfaces.eno1 = {
    ipv4.addresses = [
      {
        address = "192.168.2.17";
        prefixLength = 24;
      }
    ];
    ipv6.addresses = [
      {
        address = "fc00:c7::11";
        prefixLength = 64;
      }
    ];

    # Disable DHCP for eno1 ethernet interface.
    useDHCP = false;
  };

  networking.defaultGateway.address = "192.168.2.1";
  networking.defaultGateway.interface = "eno1";

  # Disable DHCP globally.
  networking.useDHCP = false;

  # Domain names
  networking.nameservers = [
    "1.1.1.1"
    "4.4.4.4"
    "192.168.2.1"
  ];

  # Domain names: route my domains to loopback.
  networking.extraHosts = ''
    127.0.0.1   computeroid.org
    127.0.0.1   coraless.computeroid.org
    127.0.0.1   git.computeroid.org
    127.0.0.1   xandgate.com
    127.0.0.1   git.xandgate.com
  '';

  # Domain names: use ddclient for automated dynamic DNS updates.
  services.ddclient.enable = true;
  services.ddclient.configFile = "/etc/ddclient/ddclient.conf";

  # Firewall
  networking.firewall.allowedTCPPorts = [
    22  # ssh
    80  # http
    443 # https
  ];

  # SSH client: start the SSH authentication agent
  # immediately at startup.
  programs.ssh.startAgent = true;

  # SSH server daemon
  services.openssh.enable = true;

  # SSH server: configure which IPs and ports can
  # be used to connect.
  services.openssh.listenAddresses = [
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
}
