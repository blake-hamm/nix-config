{ inputs, lib, ... }:
{
  imports = [
    # ./network.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./../../modules/profiles/minimal.nix
    inputs.microvm.nixosModules.host
  ];

  # Network
  networking.firewall.enable = true;
  networking.useDHCP = lib.mkForce false;
  networking.enableIPv6 = lib.mkForce false;
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
      "10-bond0-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig = {
          Bond = "bond0";
          PrimarySlave = true;
        };
      };
      # WIFI nic
      "10-bond0-wlp4s0" = {
        matchConfig.Name = "wlp4s0";
        networkConfig.Bond = "bond0";
      };
      # Bond network
      "10-bond0" = {
        matchConfig.Name = "bond0";
        networkConfig = {
          BindCarrier = "eno1 wlp4s0";
          Bridge = "br0";
        };
        linkConfig.RequiredForOnline = "enslaved";
      };
      # Bridge network
      "10-bond0-br0" = {
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

  # NFS
  fileSystems."/export/zpool_ssd" = {
    device = "/mnt/zpool_ssd";
    options = [ "bind" ];
  };
  fileSystems."/export/zpool_hdd" = {
    device = "/mnt/zpool_hdd";
    options = [ "bind" ];
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export           192.168.69.0/24(rw,fsid=0,no_subtree_check)
    /export/zpool_ssd 192.168.69.0/24(rw,sync,no_subtree_check,no_root_squash)
    /export/zpool_hdd 192.168.69.0/24(rw,sync,no_subtree_check,no_root_squash)
  '';
}
