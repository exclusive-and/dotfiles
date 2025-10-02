{ config, pkgs, ... }:

{
    programs.git = {
        enable = true;
        ignores = [
            ".direnv/"
            "dist-newstyle/"
            "obj_dir/"
        ];
        userEmail = "exclusiveandgate@gmail.com";
        userName = "exclusive-and";
    };
}