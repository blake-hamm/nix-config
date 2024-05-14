{ lib, ... }:
{
  networking = {
    networkmanager.enable = lib.mkForce false;
    wireless.enable = true;
    wireless.userControlled.enable = true; # To connect to wifi
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
      # Bond ethernet and wifi
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
      # Built-in Ethernet nic
      "10-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig = {
          Bond = "bond0";
          PrimarySlave = true;
        };
      };
      # WIFI nic
      "10-wlp4s0" = {
        matchConfig.Name = "wlp4s0";
        networkConfig.Bond = "bond0";
      };
      # Bond network
      "10-bond0" = {
        matchConfig.Name = [ "bond0" "vm-*" ];
        networkConfig = {
          BindCarrier = "eno1 wlp4s0";
          Bridge = "br0";
        };
        linkConfig.RequiredForOnline = "enslaved";
      };
      # Bridge network
      "10-br0" = {
        matchConfig.Name = "br0";
        bridgeConfig = { };
        address = [ "192.168.69.12/24" ];
        gateway = [ "192.168.69.1" ];
        dns = [ "192.168.69.1" ];
        linkConfig.RequiredForOnline = "yes";
        networkConfig.DHCP = "no";
      };
    };
  };
}
