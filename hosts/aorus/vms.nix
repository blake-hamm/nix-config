{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
  microvm.stateDir = "/mnt/zpool_ssd/aorus/microvms";
  microvm.autostart = [
    "aorus-k3s-server-1"
  ];
}
