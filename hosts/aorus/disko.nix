{ inputs, config, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  # # zfs support
  networking.hostId = "806a53e4"; # Required for zfs pool

  # Devices
  disko.extraRootModules = [ "zfs" ];
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
      # zfs-ssd1 = {
      #   type = "disk";
      #   device = "/dev/disk/by-id/ata-PNY_CS900_2TB_SSD_PNY225122122301009C8";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "zpool_ssd";
      #         };
      #       };
      #     };
      #   };
      # };
      # zfs-ssd2 = {
      #   type = "disk";
      #   device = "/dev/disk/by-id/ata-PNY_CS900_2TB_SSD_PNY225122122301009CB";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "zpool_ssd";
      #         };
      #       };
      #     };
      #   };
      # };
      # zfs-hdd = {
      #   type = "disk";
      #   device = "/dev/disk/by-id/ata-WDC_WD20EARS-00MVWB0_WD-WMAZA1699465";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "zpool_hdd";
      #         };
      #       };
      #     };
      #   };
      # };
    };
    # zpool = {
    #   zpool_ssd = {
    #     type = "zpool";
    #     mode = "mirror";
    #     datasets = {
    #       storage = {
    #         type = "zfs_fs";
    #         mountpoint = "/zpool_ssd";
    #       };
    #     };
    #   };
    #   zpool_hdd = {
    #     type = "zpool";
    #     datasets = {
    #       storage = {
    #         type = "zfs_fs";
    #         mountpoint = "/zpool_hdd";
    #       };
    #     };
    #   };
    # };
  };
}
