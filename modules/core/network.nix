{ host, pkgs, ... }:
{
  networking.hostName = "${host}";
  networking.networkmanager.enable = true;
}
