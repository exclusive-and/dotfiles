{
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-25.11.tar.gz";
    sha256 = "1cllhzs1263vyzr0wzzgca0njvfh04p1mf6xiq2vfd1nbr7jinpa";
  };

  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
    sha256 = "06irakwl3l32sqp3j0334g849bxvbbscqqbrzgp9xmfnka86vq8n";
  };

  nurpkgs = builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/main.tar.gz";
    sha256 = "0x8f8cr5nnp4za3q0md3szqiaq0ab6ic3w107kry8jawhakr8c0j";
  };
}
