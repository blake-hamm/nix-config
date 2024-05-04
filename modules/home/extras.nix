{ pkgs, username, ... }:
{
  environment.systemPackages = [
    pkgs.drawio
  ];
}
