{
    services.openssh = {
        enable = true;

        listenAddresses = [
            {
                addr = "192.168.2.20";
                port = 22;
            }
            {
                addr = "127.0.0.1";
                port = 22;
            }
        ];
    };

    programs.ssh.startAgent = true;
}