{ lib, ... }:
{
  networking = {
    networkmanager.enable = lib.mkForce false;
    useNetworkd = true;
    firewall.enable = true;
    useDHCP = lib.mkForce false;
    enableIPv6 = lib.mkForce false;
  };
  systemd.network = {
    enable = true;
    netdevs = {
      # Bridge for VM's and host
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
        networkConfig = {
          Bridge = "br0";
        };
      };
      # Bridge network
      "10-br0" = {
        matchConfig.Name = "br0";
        bridgeConfig = { };
        address = [ "192.168.69.13/24" ];
        gateway = [ "192.168.69.1" ];
        dns = [ "192.168.69.1" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.DHCP = "no";
      };
    };
  };
}
