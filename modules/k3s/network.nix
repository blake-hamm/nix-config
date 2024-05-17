{ i, ... }:
{
  # Network
  networking = {
    networkmanager.enable = lib.mkForce false;
    useNetworkd = true;
    firewall.enable = true;
    useDHCP = lib.mkForce false;
    enableIPv6 = lib.mkForce false;
  };
  systemd.network.enable = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Type = "ether";
    # TODO: Paramaterize the below static ip better
    address = [ "192.168.69.3${i}/24" ]; # Will conflict in cluster
    gateway = [ "192.168.69.1" ];
    dns = [ "192.168.69.1" ];
    linkConfig.RequiredForOnline = "yes";
    networkConfig.DHCP = "no";
  };

  # k3s ports
  networking.firewall.allowedTCPPorts = [
    6443
  ];
}
