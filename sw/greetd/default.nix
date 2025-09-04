{ config, pkgs, ... }:

let
    # Auto-login session; happens once on initial startup.
    initial_session = {
        command = "${pkgs.xorg.xinit}/bin/startx";
        user = "xand";
    };

    inherit (config.networking) hostName;
    inherit (config.system.nixos) distroName codeName version;

    greetText = ''
        ${distroName} ${codeName} ${version}
        -
        ${hostName}
    '';

    greetCmd = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --cmd ${pkgs.xorg.xinit}/bin/startx \
            --issue \
            --asterisks --asterisks-char "=" \
            --theme 'border=black;container=red;greet=white;prompt=white;input=black;button=yellow;action=red'
    '';

    # Greeter session.
    default_session = {
        command = greetCmd;
        user = "greeter";
    };
in
{
    environment.etc."issue".text = greetText;

    services.greetd = {
        enable = true;
        settings = {
            inherit initial_session default_session;
        };
    };
}