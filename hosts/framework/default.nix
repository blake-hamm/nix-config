{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/desktop.nix
    ./vms.nix
    ./../../modules/k3s/sops.nix
  ];
}
