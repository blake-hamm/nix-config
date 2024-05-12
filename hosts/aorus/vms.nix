{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
  microvm.autostart = [
    "aorus-k3s-server-1"
  ];
}
