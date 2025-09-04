let
    hyperionWithVr = {
        modules = [
            ./configuration.nix
        ];
    };
in
{
    nixosModules.default = ./configuration.nix;
}
