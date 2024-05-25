{ k3s_role, pkgs, kube_vip, vm_name, ... }:
{
  systemd.enableUnifiedCgroupHierarchy = false;
  services.k3s = {
    enable = true;
    clusterInit = true;
    role = "${k3s_role}";
    extraFlags = toString [
      "--debug"
      "--disable=traefik"
      "--disable=servicellb"
      "--flannel-backend=none"
      "--disable-network-policy"
      "--tls-san=${kube_vip}" # Also configured in kube-vip
      "--cluster-cidr=10.42.0.0/16" # Also configured in calico.yaml
    ];
    token = if (vm_name == "k3s-server-1") then "" else "my_token";
    serverAddr = if (vm_name == "k3s-server-1") then "" else "https://${kube_vip}:6443";
  };
  environment.systemPackages = with pkgs; [
    k3s
    argocd
    kubernetes-helm
  ];
}
