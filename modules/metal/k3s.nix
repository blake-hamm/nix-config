{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    6443
  ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--debug"
      "--disable=servicelb"
      "--disable=traefik"
      "--tls-san=192.168.69.20"
    ];
  };
  environment.systemPackages = [
    pkgs.k3s
  ];
}
