{
    username,
    
    homeDirectory ? "/home/${username}",

    extraGroups ? [],
    imports ? [],
    nixosImports ? [],
    packages ? _pkgs: [],

    ...
}:

{
    homeModules.default = {config, pkgs, ...}:
    {
        inherit imports;

        home.homeDirectory = homeDirectory;
        home.username = username;
        home.stateVersion = "24.11";

        home.packages = packages pkgs;

        news.display = "silent";

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        gtk = {
            enable = true;
            iconTheme = {
                name = "Kanagawa";
                package = pkgs.kanagawa-icon-theme;
            };
            theme = {
                name = "Kanagawa-B";
                package = pkgs.kanagawa-gtk-theme;
            };
        };
    };

    nixosModules.default = {config, pkgs, ...}:
    {
        imports = nixosImports;

        users.users.${username} = {
            inherit extraGroups;
            isNormalUser = true;
            shell = pkgs.fish;
        };
    };
}
