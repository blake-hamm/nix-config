{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  # Start vm
  microvm.autostart = [
    "my-microvm"
  ];
}
