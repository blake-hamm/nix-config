{ hostName, ... }:
{
  imports = [
    ./hosts/${hostName}.nix
  ];
}