{ lib, k, i, ... }:
{
  # Network
  networking = {
    networkmanager.enable = lib.mkForce false;
    useNetworkd = true;
    firewall.enable = lib.mkForce false; # Must be disabled for calico
    useDHCP = lib.mkForce false;
    enableIPv6 = lib.mkForce false;
    interfaces.enp0s4.mtu = 1450;
  };
  systemd.network.enable = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Type = "ether";
    # TODO: Paramaterize the below static ip better
    address = [ "192.168.69.${k}${i}/24" ];
    gateway = [ "192.168.69.1" ];
    dns = [ "192.168.69.1" ];
    linkConfig.RequiredForOnline = "yes";
    networkConfig.DHCP = "no";
  };
}
