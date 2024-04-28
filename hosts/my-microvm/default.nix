{ inputs, host, ... }:
{
  imports = [
    inputs.microvm.nixosModules.microvm
    ./../../modules/profiles/minimal.nix
  ];
  
  # Config
  users.users.bhamm.password = "";

  # Microvm
  microvm = {
    volumes = [ {
      mountPoint = "/var";
      image = "var.img";
      size = 40;
    } ];

    shares = [ {
      proto = "virtiofs";
      # proto = "9p";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    } ];

    interfaces = [
      {
        type = "user";
        id = "vm-test1";
        mac = "02:00:00:00:00:01";
      }
    ];

    forwardPorts = [
      { from = "host"; host.port = 44185; guest.port = 4185; }
    ];

    hypervisor = "qemu";
    socket = "control.socket";
  };
}