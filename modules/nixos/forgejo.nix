{ config, lib, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";

    database = {
      createDatabase = false;
      type = "postgres";
      user = "forgejo";
      passwordFile = "/secret/keys/forgejo-db";
    };

    package = pkgs.forgejo;

    settings = {
      DEFAULT.APP_NAME = "hyperion git server";
      server = {
        DOMAIN = domain;
        HTTP_PORT = 3001;
        ROOT_URL = "https://git.computeroid.org/";
        SSH_USER = "git";
        START_SSH_SERVER = false;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.nginx.virtualHosts."git.computeroid.org" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:3001";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "forgejo" ];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
    ];

    authentication = ''
      local forgejo all ident map=git-hosts
    '';
    identMap = ''
      git-hosts git forgejo
    '';

    settings.password_encryption = "scram-sha-256";
  };

  users.groups."git" = {
    members = [ "git" ];
  };

  users.users."git" = {
    group = "git";
    home = "/var/lib/forgejo";
    isSystemUser = true;
    useDefaultShell = true;
  };
}
