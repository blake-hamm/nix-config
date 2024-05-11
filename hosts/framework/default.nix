{ inputs, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/desktop.nix
    inputs.microvm.nixosModules.host
  ];

  microvm.autostart = [
    "framework-vm-k3s-server-1"
  ];

}
