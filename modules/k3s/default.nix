{ system, inputs, pkgs, username, ... }:
let
  buildVM = { kube_vip, n }:
    let
      i = toString n;
      vm_name = "k3s-server-${i}";
    in
    {
      "${vm_name}" = pkgs.lib.nixosSystem {
        inherit system;
        modules = [ (import ./system.nix) ];
        specialArgs = {
          host = vm_name;
          inherit inputs username vm_name i kube_vip;
        };
      };
    };
in
{
  buildConfig = { kube_vip, n }:
    let
      buildConfig' = { kube_vip, n }:
        if n <= 0 then { }
        else
          let result = buildVM { kube_vip = kube_vip; n = n; };
          in
          result // buildConfig' { kube_vip = kube_vip; n = n - 1; };
    in
    buildConfig' { kube_vip = kube_vip; n = n; };
}
