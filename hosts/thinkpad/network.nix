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
      # Bond network
      "10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };
    };
    networks = {
      # Usb Ethernet 2.5g nic as primary
      "10-enp0s20f0u2" = {
        matchConfig.Name = "enp0s20f0u2";
        networkConfig = {
          Bond = "bond0";
          PrimarySlave = true;
        };
      };
      # Built-in Ethernet nic
      "10-enp0s31f6" = {
        matchConfig.Name = "enp0s31f6";
        networkConfig.Bond = "bond0";
      };
      # Bond network
      "10-bond0" = {
        matchConfig.Name = [ "bond0" "vm-*" ];
        networkConfig = {
          Bridge = "br0";
        };
      };
      # Bridge network
      "10-br0" = {
        matchConfig.Name = "br0";
        bridgeConfig = { };
        address = [ "192.168.69.14/24" ];
        gateway = [ "192.168.69.1" ];
        dns = [ "192.168.69.1" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.DHCP = "no";
      };
    };
  };
}
