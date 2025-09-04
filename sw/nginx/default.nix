{ config, pkgs, ... }:

{
    services = {
        nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
        };

        postgresql = {
            enable = true;
            package = pkgs.postgresql_15;
        };
    };

    security.acme = {
        acceptTerms = true;

        defaults = {
            email = "exclusiveandgate@gmail.com";
            group = "certs";
        };

        certs =
            builtins.mapAttrs (name: value: {
                email = "exclusiveandgate@gmail.com";
            })
            config.services.nginx.virtualHosts;
    };

    users.groups.certs = { };
}