{ pkgs, username, ... }:
{
  systemd.tmpfiles.rules = [
    "C+ /var/lib/rancher/k3s/server/manifests/custom 0755 root root - /home/${username}/repos/k3s-config/manifests"
  ];
  networking.firewall.allowedTCPPorts = [
    6443
  ];
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--debug"
      "--disable=traefik"
      "--disable=servicellb"
      "--tls-san=192.168.69.20"
    ];
  };
  environment.systemPackages = [
    pkgs.k3s
    pkgs.argo
    pkgs.argocd
  ];
}
