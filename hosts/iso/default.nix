{ pkgs, lib, ... }:
{
  imports = [
    ./../../modules/profiles/minimal.nix
  ];

  # use the latest Linux kernel"${out}
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "zfs" ];

  # Override settings
  networking.networkmanager.enable = lib.mkForce false;
}
