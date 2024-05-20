{ inputs, username, vm_name, i, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  # Config
  users.users.${username}.password = ""; # TODO: Replace with vault

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  # Microvm
  microvm = {
    vcpu = 4;
    mem = 8 * 1024; # 8gb

    volumes = [{
      mountPoint = "/var";
      image = "/mnt/zpool_ssd/microvms/${vm_name}.img";
      # Requires permissions (replace with ansible?):
      # sudo chown -R microvm:kvm /mnt/zpool_ssd/aorus/microvms
      # sudo chmod -R 755 /mnt/zpool_ssd/aorus/microvms
      size = 51200; # 50 gb
    }];

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
        id = "vm-k3s-${i}";
        mac = "02:00:00:00:00:0${i}";
      }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };
}
