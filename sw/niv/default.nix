{ config
, lib
, pkgs
, ...
} @ args:
{
  environment.systemPackages = with pkgs; [
    niv
  ];
}
