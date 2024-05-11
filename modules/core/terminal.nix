{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    tree
    htop
    kitty
    jq
  ];
}
