{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    
    profiles = {
      default = {
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;
        extensions = with pkgs.vscode-extensions; [
          haskell.haskell
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          mkhl.direnv
          mshr-h.veriloghdl
        ];
      };
    };
  };
}
