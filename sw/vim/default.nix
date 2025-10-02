{ config, pkgs, ... }:

let
    challengerDeep = pkgs.vimUtils.buildVimPlugin {
        name = "challenger-deep";
        src = pkgs.fetchFromGitHub {
            owner = "challenger-deep-theme";
            repo = "vim";
            rev = "e3d5b7d9711c7ebbf12c63c2345116985656da0d";
            hash = "sha256-2lIPun5OjaoHSG2BdnX9ztw3k9whVlBa9eB2vS8Htbg=";
        };
    };

    vimrcConfig = {
        packages.myPlugins = with pkgs.vimPlugins; {
            start = [
                vim-nix
                vim-lastplace
                haskell-vim
                challengerDeep
            ];
            opt = [];
        };
        customRC = builtins.readFile ./vimrc;
    };

    vim = pkgs.vim_configurable.customize {
        name = "vim";
        inherit vimrcConfig;
    };
in
{
    environment.systemPackages = [
        vim
    ];
}
