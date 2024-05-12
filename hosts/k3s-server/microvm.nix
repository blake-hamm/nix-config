{ inputs, username, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
  ];

  # Config
  users.users.${username}.password = "";

  # Microvm
  microvm = {
    vcpu = 2;
    mem = 4096; # 4gb
    volumes = [{
      mountPoint = "/var";
      image = "var.img";
      size = 10240; # 10 gb
    }];

    shares = [{
      proto = "virtiofs";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    hypervisor = "qemu";
    socket = "control.socket";
  };
}
