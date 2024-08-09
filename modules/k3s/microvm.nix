{ inputs, username, vm_name, k, i, ... }:
let
  mac_address = "02:00:00:00:00:${k}${i}";
in
{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  # Config
  users.users.${username}.password = ""; # TODO: Replace with vault
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${mac_address}", NAME="enp0s4"
  '';

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  # Microvm
  microvm = {
    vcpu = 4;
    mem = 8 * 1024; # 8gb
    balloonMem = 2 * 1024;

    volumes = [
      {
        mountPoint = "/var";
        image = "/mnt/zpool_ssd/microvms/${vm_name}_var.img";
        # Requires permissions (replace with ansible?):
        # sudo chown -R microvm:kvm /mnt/zpool_ssd/aorus/microvms
        # sudo chmod -R 755 /mnt/zpool_ssd/aorus/microvms
        size = 20480; # 20 gb
      }
      {
        mountPoint = "/etc";
        image = "/mnt/zpool_ssd/microvms/${vm_name}_etc.img";
        # Requires permissions (replace with ansible?):
        # sudo chown -R microvm:kvm /mnt/zpool_ssd/aorus/microvms
        # sudo chmod -R 755 /mnt/zpool_ssd/aorus/microvms
        size = 20480; # 20 gb
      }
    ];

    shares = [{
      #proto = "9p";
      proto = "virtiofs";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    interfaces = [
      {
        type = "tap";
        id = "vm-${vm_name}";
        mac = mac_address; # Add a rule to ethernet interface
      }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };
}
