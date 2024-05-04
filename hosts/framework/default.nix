{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/profiles/desktop.nix
    ./../../modules/metal/vm_host.nix
  ];
  networking.networkmanager.enable = true;
  # networking.interfaces.wlp1s0.ipv4.addresses = [{
  #   address = "192.168.69.40";
  #   prefixLength = 24;
  # }];
  # networking.defaultGateway = "192.168.69.1";
  # networking.nameservers = [ "192.168.69.1" "1.1.1.1" "1.0.0.1" ];
  # systemd.network = {
  #   enable = true;
  #   networks."10-wlp1s0" = {
  #     matchConfig.Name = "wlp1s0";
  #     address = [ "192.168.69.40/24" ];
  #     gateway = [ "192.168.69.1" ];
  #     dns = [ "192.168.69.1" ];
  #     linkConfig.RequiredForOnline = "yes";
  #   };
  # };
}
