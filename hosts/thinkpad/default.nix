{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
    ./disko.nix
    ./../../modules/hardware/nfs-client.nix
    ./network.nix
    # ./vms.nix
    ./../../modules/hardware/laptop-server.nix
    ./../../modules/k3s/sops.nix
  ];
}
