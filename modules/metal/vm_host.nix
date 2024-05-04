{ inputs, ... }:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];
}
