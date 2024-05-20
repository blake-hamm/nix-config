{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
    ./disko.nix
    ./../../modules/hardware/nfs_client.nix
    ./network.nix
    ./vms.nix
  ];
}
