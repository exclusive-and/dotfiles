lib: pkgs:

let

  nixosSplicePackages = {
    inherit lib;
    inherit (pkgs) nixosSystem;
  };

in

{
  callNixosConfiguration =
    lib.callPackageWith (pkgs // nixosSplicePackages);
}
