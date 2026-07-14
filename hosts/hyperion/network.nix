{
  networking.defaultGateway.address = "192.168.2.1";
  networking.defaultGateway.interface = "eno1";

  networking.extraHosts = ''
    127.0.0.1   computeroid.org
    127.0.0.1   coraless.computeroid.org
    127.0.0.1   git.computeroid.org
    127.0.0.1   xandgate.com
    127.0.0.1   git.xandgate.com
  '';

  networking.firewall.allowedTCPPorts = [
    22  # ssh
    80  # http
    443 # https
  ];

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
    useDHCP = false;
  };

  networking.nameservers = [
    "1.1.1.1"
    "4.4.4.4"
    "192.168.2.1"
  ];

  networking.useDHCP = false;

  services.ddclient = {
    enable = true;
    configFile = "/etc/ddclient/ddclient.conf";
  };

  programs.ssh.startAgent = true;
  services.openssh.enable = true;
  services.openssh.listenAddresses = [
    {
      addr = "127.0.0.1";
      port = 22;
    }
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
