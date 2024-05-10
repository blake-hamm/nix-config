{ host, pkgs, ... }:
{
  # TODO: Handle server vs. desktop for network

  # Both
  networking.hostName = "${host}";
  # networking.wireless.enable = true; # For wpa_supplicant just in case
  # environment.systemPackages = with pkgs; [
  #   wpa_supplicant # Just in case
  # ];

  # Server ethernet
  # systemd.network = {
  #   enable = true;
  #   networks."10-wlp1s0" = {
  #     matchConfig.Name = "wlp1s0";
  #     address = ["192.168.69.40/24"];
  #     gateway = ["192.168.69.1"];
  #     dns = ["192.168.69.1"];
  #     # routes = [
  #     #   { routeConfig.Gateway = "192.168.69.1"; }
  #     # ];
  #     # bridge = ["br0"];
  #     linkConfig.RequiredForOnline = "yes";
  #   };
  # };
  # networking.useNetworkd = true;

  # Desktop wifi
  networking.networkmanager.enable = true;
  # networking.interfaces.wlp1s0.ipv4.addresses = [{
  #   address = "192.168.69.40";
  #   prefixLength = 24;
  # }];
  # networking.defaultGateway = "192.168.69.1";
  # networking.nameservers = [ "192.168.69.1" "1.1.1.1" "1.0.0.1" ];
}
