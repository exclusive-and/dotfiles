{ config, pkgs, ... }:

{
    programs.git = {
        enable = true;
        ignores = [
            ".direnv/"
            "dist-newstyle/"
            "obj_dir/"
        ];
        settings.user.email = "exclusiveandgate@gmail.com";
        settings.user.name = "exclusive-and";
        signing.format = "openpgp";
    };
}