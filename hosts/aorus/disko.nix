{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77845B74E3";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              end = "-32G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
              };
            };
          };
        };
      };
      zfs-hdd = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD20EARS-00MVWB0_WD-WMAZA1699465";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zhdd";
              };
            };
          };
        };
      };
    };
    zpool = {
      zhdd = {
        type = "zpool";
        mountpoint = "/zhdd";
        rootFsOptions = {
          canmount = "off";
        };
        datasets = {
          fs = {
            type = "zfs_fs";
            mountpoint = "/zhdd/fs";
          };
        };
      };
    };
  };
}
