{ config, pkgs, ... }:

{
    hardware = {
        steam-hardware.enable = true;
    };

    services.monado = {
        enable = true;
        defaultRuntime = true;
        highPriority = true;

        /*
        package = pkgs.monado.overrideAttrs (old: {
            version = "latest";

            src = pkgs.fetchFromGitLab {
                domain = "gitlab.freedesktop.org";
                owner = "monado";
                repo = "monado";
                rev = "c80de9e7cacf2bf9579f8ae8c621d8bf16e85d6c";
                hash = "sha256-ciH26Hyr8FumB2rQB5sFcXqtcQ1R84XOlphkkLBjzvA=";
            };

            patches = [];
        });
        */
    };

    systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
        U_PACING_COMP_MIN_TIME_MS = "5";
    };
}