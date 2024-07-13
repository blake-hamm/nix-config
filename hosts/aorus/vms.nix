{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
  microvm.autostart = [
    "k3s-server-3"
    "k3s-agent-2"
    "k3s-agent-3"
  ];
}
