# This file contains instructions to deploy config to machines

## Apply changes
```bash
colmena apply-local --sudo # Apply colmena on my local
colmena apply --on @server # apply colmena on all machines with 'server' tag
#sudo nixos-rebuild switch --flake .#framework # rebuild the standard way
```


## Setup new machine
### Build and flash iso image
*NOTE: This only creates a live iso image with my minimal configuration, to automate the full install, we need to checkout disco and create some kind of sccript like https://haseebmajid.dev/posts/2024-02-04-how-to-create-a-custom-nixos-iso/*
```bash
nix build .#nixosConfigurations.minimal-iso.config.system.build.isoImage
dd if=result/iso/*.iso of=/dev/sdX status=progress # Or use balena etcher
sync
```

### Boot from live iso
Once booted into your live environment, you need to manually setup the network following the official docs - https://nixos.org/manual/nixos/stable/index.html#sec-installation. If you have ethernet, you can skip this.

Next, you should be able to ssh into your live environment. Find the ip address and ssh into it with your user.

Now, you will want to view the device id's. Find the device with `lsblk` and find the id with `udevadm info /dev/sdX`. Once you have this info, construct your disko config independent of your flake project. To apply the disko config, run:
```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nix-config/hosts/machine/disko.nix
```

Once your disk is setup, you can integrate the disko config into your flake project and push to the repo.

Next, you need to put your hardware config into your git project. To generate a hardware config, run `nixos-generate-config --no-filesystems --show-hardware-config` and copy it to your host configs. Finish your host config using standard flake (without colmena).

*TODO: Use nixos anywhere*

After host config is finalized and the `flake.nix` is updated, copy this repo to `/mnt/nix-config` and install with `sudo nixos-install --no-root-passwd --flake /mnt/nix-config#the-machine`.

Next, you need to setup a password for your user **before** rebooting. Run `sudo nixos-enter --root /mnt -c 'passwd <username>'` to set the password.

Finally, you can reboot into your system! Once booted in, your existing `/nix-config` directory during the live boot should be accessible - you can delete this. Refactor to use colmena instead of standard flakes, test it and push up to the origin.

*More automation potential here - https://github.com/zhaofengli/colmena/issues/42#issuecomment-1004528027*


### Virtual Machines
It is best practice to keep vm flakes seperate from the host. This ensures rebuilding the host doesn't take too long or hog resources. Once we have a good CI/CD setup (argo workflows), we will automated the following steps.

To create a vm for the first time run:
```bash
sudo mkdir -p /mnt/zpool_ssd/aorus/microvms # Create .img directory
sudo chown -R microvm:kvm /mnt/zpool_ssd/aorus/microvms # Give kvm group and microvm user ownership
sudo chmod -R 755 /mnt/zpool_ssd/aorus/microvms
sudo microvm -f git+file:///home/bhamm/nix-config -c aorus-k3s-server-1
# sudo microvm -f github:blake-hamm/nix-config/feature/k3s -c aorus-k3s-server-1
sudo systemctl start microvm@aorus-k3s-server-1.service
```

`microvm.autostart` will ensure the microvm always starts up.


To update and reboot a vm run (normally what you need to do):
```bash
sudo microvm -Ru aorus-k3s-server-1
```

To remove a VM, run:
```bash
sudo systemctl stop microvm@aorus-k3s-server-1
sudo rm -rf /var/lib/microvms/aorus-k3s-server-1
```


#### VM Troubleshooting
In case you need to access a vm, you can ssh into the host and then ssh into the vm:
`ssh bhamm@localhost -p 14185 -o StrictHostKeyChecking=no`

For troubleshooting a new vm, you can change `proto = "9p";` in the vm config and run the following command:
`sudo nix run .#framework-vm-k3s-server-1`

### ZFS
*TODO: Use my ansible playbook instead(?)*
Generally following - https://github.com/nmasur/dotfiles/blob/b546d5b43ab8ff148532a65a43d0f3ad50582e33/docs/zfs.md

Create pool:
```bash
# zpool_hdd
sudo zpool create -f  -m /mnt/zpool_hdd zpool_hdd /dev/disk/by-id/ata-WDC_WD20EARS-00MVWB0_WD-WMAZA1699465

# zpool_ssd
sudo zpool create -f  -m /mnt/zpool_ssd -o ashift=12 zpool_ssd mirror \
  /dev/disk/by-id/ata-PNY_CS900_2TB_SSD_PNY225122122301009C8 \
  /dev/disk/by-id/ata-PNY_CS900_2TB_SSD_PNY225122122301009CB
```
