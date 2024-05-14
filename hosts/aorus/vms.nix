{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
  microvm.autostart = [
    "aorus-k3s-server-1"
    # "aorus-k3s-server-2"
    # "aorus-k3s-server-3"
  ];
}
