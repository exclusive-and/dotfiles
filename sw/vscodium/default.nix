{ config, pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        enableExtensionUpdateCheck = true;
        enableUpdateCheck = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
            haskell.haskell
            jnoortheen.nix-ide
            llvm-vs-code-extensions.vscode-clangd
            mkhl.direnv
            mshr-h.veriloghdl
        ];
    };
}
