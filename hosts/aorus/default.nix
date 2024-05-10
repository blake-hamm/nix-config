{ inputs, pkgs, ... }:
{
  imports = [
    # ./network.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
  ];
}
