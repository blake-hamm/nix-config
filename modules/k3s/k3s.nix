{ pkgs, kube_vip, ... }:
{
  systemd.enableUnifiedCgroupHierarchy = false;
  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "server";
    extraFlags = toString [
      "--debug"
      "--disable=traefik"
      "--disable=servicellb"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--tls-san=${kube_vip}" # Also configured in kube-vip
      "--cluster-cidr=10.42.0.0/16" # Also configured in calico.yaml
    ];
  };
  environment.systemPackages = with pkgs; [
    k3s
    argocd
    kubernetes-helm
  ];
}
