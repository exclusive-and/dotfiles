{ config, pkgs, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "exclusiveandgate@gmail.com";
      group = "certs";
    };
    certs = config.services.nginx.virtualHosts
      |> builtins.mapAttrs (_: _: { email = "exclusiveandgate@gmail.com"; });
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  users.groups.certs = { };
}
