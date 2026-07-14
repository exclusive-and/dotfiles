{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  # Pull ragenix to safely encrypt any secrets in our configurations.
  inputs.ragenix = {
    url = "github:yaxitech/ragenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Pull NUR for some overlays. Currently only used for rycee's firefox-addons.
  inputs.nurpkgs = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nix-auth = {
    url = "github:numtide/nix-auth";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nix-monitored.url = "github:ners/nix-monitored";

  # Grab the nixpkgs-unstable branch in case we need more up-to-date versions of packages
  # that haven't been incorporated into a stable release yet.
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = inputs: import ./pkgs/nixos/build-os.nix {
    inherit inputs;
    inherit (inputs.nixpkgs) lib;
    inherit (inputs.nixpkgs.lib) nixosSystem;

    targets = [
      ./hosts/hyperion
      # ./hosts/lemur-pro
    ];

    #
    # Cryptographic key pairs for encrypting and decrypting secrets.
    #
    keys = {
      public = import ./secrets/keys/public.nix;

      /* DO NOT PUBLISH PRIVATE KEYS! */
      private = [
        "/root/.ssh/id_ed25519_hyperion_secrets"
        # "/root/.ssh/id_ed25519_lemurpro_secrets"
        # "/root/.ssh/id_ed25519_servarica_secrets"
      ];
    };

    secrets = ./secrets;

    origami = import ./modules/origami;
  };
}
