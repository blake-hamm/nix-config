{ system, inputs, pkgs, username, ... }:
let
  buildVM = { vm_host, kube_vip, n }:
    let
      i = toString n;
      vm_name = "${vm_host}-k3s-server-${i}";
    in
    {
      "${vm_name}" = pkgs.lib.nixosSystem {
        inherit system;
        modules = [ (import ./system.nix) ];
        specialArgs = {
          host = vm_name;
          inherit inputs username vm_name vm_host i kube_vip;
        };
      };
    };
in
{
  buildConfig = { vm_host, kube_vip, n }:
    let
      buildConfig' = { vm_host, kube_vip, n }:
        if n <= 0 then { }
        else
          let result = buildVM { vm_host = vm_host; kube_vip = kube_vip; n = n; };
          in
          result // buildConfig' { vm_host = vm_host; kube_vip = kube_vip; n = n - 1; };
    in
    buildConfig' { vm_host = vm_host; kube_vip = kube_vip; n = n; };
}
