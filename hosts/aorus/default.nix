{ inputs, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
  ];
}
