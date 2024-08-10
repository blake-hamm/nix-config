{ pkgs, kube_vip, host, config, lib, ... }:
{
  systemd.enableUnifiedCgroupHierarchy = false;
  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "server";
    extraFlags = toString [
      "--debug"
      "--disable=traefik"
      "--disable=servicelb"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--tls-san=${kube_vip}" # Also configured in kube-vip
      "--cluster-cidr=10.42.0.0/16" # Also configured in calico.yaml
      "--kube-proxy-arg=ipvs-strict-arp=true" # Required for metallb
    ];
    serverAddr = "https://${kube_vip}:6443";
  };
  environment.systemPackages = with pkgs; [
    k3s
    argocd
    kubernetes-helm
    nfs-utils
  ];
  networking.firewall.enable = lib.mkForce false; # Must be disabled for calico
  # TODO: fine grain firewall

  # Sops secret for token
  sops.secrets.k3s_token = { };
  services.k3s.tokenFile = config.sops.secrets.k3s_token.path;

}
