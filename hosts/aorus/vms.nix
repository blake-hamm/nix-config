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
  networking.eno1.mtu = 1450; # For k3s vxlan - https://docs.tigera.io/calico/latest/networking/configuring/mtu
}
