{ inputs, username, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  # Config
  users.users.${username}.password = ""; # TODO: Replace with vault

  # Microvm
  microvm = {
    vcpu = 2;
    mem = 4096; # 4gb

    volumes = [{
      mountPoint = "/var";
      image = "/mnt/zpool_ssd/aorus/microvms/var.img";
      # Requires permissions (replace with ansible?):
      # sudo chown -R microvm:kvm /mnt/zpool_ssd/aorus/microvms
      # sudo chmod -R 755 /mnt/zpool_ssd/aorus/microvms
      size = 10240; # 10 gb
    }];

    shares = [{
      proto = "virtiofs";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    interfaces = [
      {
        type = "tap";
        id = "vm-test";
        mac = "02:00:00:00:00:01";
      }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };

  systemd.network.enable = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Type = "ether";
    address = [ "192.168.69.30/24" ];
    gateway = [ "192.168.69.1" ];
    dns = [ "192.168.69.1" ];
    linkConfig.RequiredForOnline = "yes";
    networkConfig.DHCP = "no";
  };
}
