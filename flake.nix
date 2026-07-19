{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    nix-auth = {
      url = "github:numtide/nix-auth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Pull ragenix to safely encrypt any secrets in our configurations.
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        agenix.follows = "agenix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Pull NUR for some overlays. Currently only used for rycee's firefox-addons.
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Grab the nixpkgs-unstable branch in case we need more up-to-date versions of packages
    # that haven't been incorporated into a stable release yet.
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    nix-monitored.url = "github:ners/nix-monitored";
  };

  outputs = inputs: import ./pkgs/nixos/build-os.nix {
    inherit inputs;
    inherit (inputs.nixpkgs) lib;
    inherit (inputs.nixpkgs.lib) nixosSystem;

    targets = [
      ./hosts/hyperion
      # ./hosts/lemur-pro
      ./hosts/lenovo-legion
    ];

    #
    # Cryptographic key pairs for encrypting and decrypting secrets.
    #
    # keys = {
    #  public = import ./secrets/keys/public.nix;

    #  /* DO NOT PUBLISH PRIVATE KEYS! */
    #  private = [
    #    "/root/.ssh/id_ed25519_hyperion_secrets"
    #    # "/root/.ssh/id_ed25519_lemurpro_secrets"
    #    # "/root/.ssh/id_ed25519_servarica_secrets"
    #  ];
    #};

    #secrets = ./secrets;
  };
}
