{
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-25.05.tar.gz";
    sha256 = "1cllhzs1263vyzr0wzzgca0njvfh04p1mf6xiq2vfd1nbr7jinpa";
  };

  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "0d41gr0c89a4y4lllzdgmbm54h9kn9fjnmavwpgw0w9xwqwnzpax";
  };

  nurpkgs = builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
    sha256 = "0x8f8cr5nnp4za3q0md3szqiaq0ab6ic3w107kry8jawhakr8c0j";
  };
}
