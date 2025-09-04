{ config, pkgs, ... }:

{
    xdg.configFile."openxr/1/active_runtime.json".source = "/run/current-system/sw/share/openxr/1/openxr_monado.json";

    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
            "config" :
            [
                "${config.xdg.dataHome}/Steam/config"
            ],
            "external_drivers" : null,
            "jsonid" : "vrpathreg",
            "log" :
            [
                "${config.xdg.dataHome}/Steam/logs"
            ],
            "runtime" :
            [
                "${pkgs.opencomposite}/lib/opencomposite"
            ],
            "version" : 1
        }
    '';
}
