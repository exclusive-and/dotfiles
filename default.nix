# This script is the main entry point for building my system configurations.
{
  sources
, ...
}@args:

let

  defaultArgs = {

    #
    # List of target 
    #
    targets = [
      ./hosts/hyperion
      ./hosts/lemur-pro
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

    # Make sure that 'sources' get passed along with the defaults.
    inherit sources;

    #
    # Import standalone nixpkgs library functions.
    #
    lib = import "${sources.nixpkgs}/lib";

    inherit (sources) home-manager nix-auth nix-monitored nurpkgs ragenix;

    #
    #
    #
    origami = import ./modules/origami;

    #
    # Import the nixosSystem function. This is almost identical
    # to its counterpart in the nixpkgs flake. See:
    #
    #   https://github.com/NixOS/nixpkgs/blob/bcd464ccd2a1a7cd09aa2f8d4ffba83b761b1d0e/flake.nix#L64
    #
    nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  };
  
in
  import ./lib/nixos defaultArgs

# Here are the intended ways to invoke this:
#
#  1. As a standalone script; i.e. by invoking `nix-build [path/to/default.nix]`
#     in an appropriate shell interpreter. In standalone mode, every argument
#     uses its default value automatically. Most of the defaults are defined in:
#
#       * the `defaultArgs` attribute set in this script; or
#
#       * the repositories pinned by Niv in `./nix/sources.*` in the case of external
#         dependencies.
#
#  2. Imported into another script and then called as a function. This mode allows
#     the caller to pass their own values for arugments. If the caller doesn't
#     specify a value to use for an argument, that argument falls back to its default.
#
#  3. Via a Flake. There are some quirks to make this script work as intended
#     with Flakes:
#
#       * I recommend overriding the `sources` argument with the Flake's inputs.
#         This is so that non-flake Niv pins won't end up conflicting with
#         the ones from `flake.lock` anywhere in the downstream build process.
#
#       * It's also probably a good idea to override both `lib` and `nixosSystem`
#         with the ones from the nixpkgs flake.
#
#       * [Say something about compatibility with the flake input schema here...]
