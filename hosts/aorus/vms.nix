{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
  # TODO: Figure out how to run vm on zfs
  # fileSystems."/var/lib/microvms" = {
  #   device = "/mnt/zpool_ssd";
  #   options = [ "bind" ];
  # };
  # users.users.microvm.extraGroups = [ "disk" ];
  microvm.autostart = [
    "aorus-k3s-server-1"
  ];
}
