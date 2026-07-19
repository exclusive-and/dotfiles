{
  fetchFromGitHub
, lib
, vimPlugins
, vimUtils
, vim-full
}:

let

  vim-challenger-deep = vimUtils.buildVimPlugin {
    name = "challenger-deep";
    src = fetchFromGitHub {
      owner = "challenger-deep-theme";
      repo = "vim";
      rev = "e3d5b7d9711c7ebbf12c63c2345116985656da0d";
      hash = "sha256-2lIPun5OjaoHSG2BdnX9ztw3k9whVlBa9eB2vS8Htbg=";
    };
  };

in
vim-full.customize {
  name = "vim";
  vimrcConfig = {
    customRC = builtins.readFile ./vimrc;
    packages.myPlugins = {
      start = [
        vim-challenger-deep
        vimPlugins.vim-nix
        vimPlugins.vim-lastplace
        vimPlugins.haskell-vim
      ];
      opt = [];
    };
  };
}
