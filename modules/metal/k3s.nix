{ pkgs, username, ... }:
{
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
      "--flannel-backend=none"
      "--disable-network-policy"
      "--tls-san=192.168.69.19" # Also configured in kube-vip
      "--cluster-cidr=10.42.0.0/16" # Also configured in calico.yaml
    ];
  };
  environment.systemPackages = with pkgs; [
    k3s
    argocd
    # pkgs.argo
    # pkgs.calico-cni-plugin
  ];
}
