{ lib, system, inputs, pkgs, username, ... }:
{
  build = { vm_host }:
    let
      i = "0";
      kube_vip = "192.168.69.19";
      vm_name = "${vm_host}-k3s-server-${i}";
    in
    {
      "${vm_name}" = lib.nixosSystem {
        inherit system;
        modules = [ (import ./system.nix) ];
        specialArgs = {
          host = vm_name;
          inherit inputs username vm_name vm_host i kube_vip;
        };
      };
    };
}
