{ inputs, host, username, host_ssh_port, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
    ./../profiles/minimal.nix
  ];

  # Config
  users.users.${username}.password = "";

  # Microvm
  microvm = {
    volumes = [{
      mountPoint = "/var";
      image = "var.img";
      size = 40;
    }];

    shares = [{
      # proto = "virtiofs";
      proto = "9p";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    interfaces = [
      {
        type = "user";
        id = "vm-user";
        mac = "02:00:00:00:00:01";
      }
    ];

    forwardPorts = [
      { from = "host"; host.port = host_ssh_port; guest.port = 4185; }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };
}
