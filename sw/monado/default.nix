{ config, pkgs, ... }:

{
    hardware = {
        steam-hardware.enable = true;
    };

    services.monado = {
        enable = true;
        defaultRuntime = true;
        highPriority = true;

        package = pkgs.monado.overrideAttrs (old: {
            version = "latest";

            src = pkgs.fetchFromGitLab {
                domain = "gitlab.freedesktop.org";
                owner = "monado";
                repo = "monado";
                rev = "0d39a0c50904ac81add836ca97aca08c766db316";
                hash = "sha256-sKdOGDv54X6J1HYIAr2GhqlNoByEUqFcX1dLAiERkS0=";
            };

            patches = [];

            cmakeFlags = old.cmakeFlags ++ [
                (pkgs.lib.cmakeBool "XRT_BUILD_DRIVER_SURVIVE" true)
            ];
        });
    };

    systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
        U_PACING_COMP_MIN_TIME_MS = "5";
    };
}
