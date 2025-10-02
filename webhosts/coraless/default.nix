{ config, pkgs, ... }:

let
    domain = "coraless.computeroid.org";
in
{
    services.nginx.virtualHosts."${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
            tryFiles = "$uri /anti-coral.png =404";
        };
        root = "/var/lib/coraless-site";
    };
}