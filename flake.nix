{
  description = "hyperion OS configuration";

  inputs.nixpkgs.url = "nixpkgs/nixos-25.11";

  inputs.ragenix = {
    url = "github:yaxitech/ragenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, ragenix}:
    import ./. {
      inherit nixpkgs ragenix;
      system = "x86_64-linux";
    };
}
