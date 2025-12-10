{
  description = "hyperion OS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-25.11";

  outputs = {self, nixpkgs}:
    import ./. {
      inherit nixpkgs;
      system = "x86_64-linux";
    };
}
