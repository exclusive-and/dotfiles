{ config, lib, pkgs, ... }:

let
    domain = "git.computeroid.org";
in
{
    users = {
        groups.git = {
            members = [ "git" ];
        };

        users = {
            git = {
                group = "git";
                home = "/var/lib/forgejo";
                isSystemUser = true;
                useDefaultShell = true;
            };
        };
    };

    services = {
        forgejo = {
            enable = true;
            package = pkgs.forgejo;

            user = "git";
            group = "git";

            settings = {
                DEFAULT.APP_NAME = "hyperion git server";
                server = {
                    DOMAIN = domain;
                    HTTP_PORT = 3001;
                    ROOT_URL = "https://${domain}/";
                    SSH_USER = "git";
                    START_SSH_SERVER = false;
                };
                service = {
                    DISABLE_REGISTRATION = true;
                };
            };

            database = {
                createDatabase = false;
                type = "postgres";
                user = "forgejo";
                passwordFile = "/secret/keys/forgejo-db";
            };
        };

        nginx.virtualHosts."${domain}" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
                proxyPass = "http://localhost:3001";
            };
        };

        postgresql = {
            enable = true;

            authentication = ''
                local forgejo all ident map=git-hosts
            '';

            ensureDatabases = [
                "forgejo"
            ];

            ensureUsers = [
                {
                    name = "forgejo";
                    ensureDBOwnership = true;
                }
            ];

            identMap = ''
                git-hosts git forgejo
            '';

            settings = {
                password_encryption = "scram-sha-256";
            };
        };
    };
}