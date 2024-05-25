{ system, inputs, pkgs, username, ... }:
let
  buildVM = { kube_vip, k3s_role, n }:
    let
      i = toString n;
      k = if k3s_role == "server" then "2" else "3";
      vm_name = "k3s-${k3s_role}-${i}";
    in
    {
      "${vm_name}" = pkgs.lib.nixosSystem {
        inherit system;
        modules = [ (import ./system.nix) ];
        specialArgs = {
          host = vm_name;
          inherit inputs username vm_name i k kube_vip k3s_role;
        };
      };
    };
in
{
  buildConfig = { kube_vip, k3s_role, n }:
    let
      buildConfig' = { kube_vip, k3s_role, n }:
        if n <= 0 then { }
        else
          let result = buildVM { kube_vip = kube_vip; k3s_role = k3s_role; n = n; };
          in
          result // buildConfig' { kube_vip = kube_vip; k3s_role = k3s_role; n = n - 1; };
    in
    buildConfig' { kube_vip = kube_vip; k3s_role = k3s_role; n = n; };
}
