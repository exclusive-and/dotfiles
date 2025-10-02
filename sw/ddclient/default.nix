{ config, pkgs, ... }:

{
    services.ddclient = {
        enable = true;
        configFile = "/etc/ddclient/ddclient.conf";
    };
}