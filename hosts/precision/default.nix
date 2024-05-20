{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
    ./disko.nix
    ./../../modules/hadware/nfs_client.nix
    ./network.nix
    ./vms.nix
  ];
}
