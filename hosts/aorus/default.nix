{ lib, ... }:
{
  imports = [
    # ./network.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
  ];

  # Network
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkForce false;
  networking.enableIPv6 = lib.mkForce false;
  systemd.network = {
    enable = true;
    # Bridge for vms
    netdevs = {
      "10-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };
    networks = {
      # Built-in Ethernet nic
      "10-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
        networkConfig.DHCP = "no";
      };
      # WIFI nic
      "10-wlp4s0" = {
        matchConfig.Name = "wlp4s0";
        address = [ "192.168.69.13/24" ];
        gateway = [ "192.168.69.1" ];
        dns = [ "192.168.69.1" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.DHCP = "no";
      };
      # Bridge network
      "10-br0" = {
        matchConfig.Name = "br0";
        bridgeConfig = { };
        address = [ "192.168.69.12/24" ];
        gateway = [ "192.168.69.1" ];
        dns = [ "192.168.69.1" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.IPForward = "yes";
        networkConfig.DHCP = "no";
      };
    };
  };
}
