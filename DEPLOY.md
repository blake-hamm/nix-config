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

*TODO: Use nixos anywhere - potential way to run with colmena - https://github.com/zhaofengli/colmena/issues/60*

After host config is finalized and the `flake.nix` is updated, copy this repo to `/mnt/nix-config` and install with `sudo nixos-install --no-root-passwd --flake /mnt/nix-config#the-machine`.

Next, you need to setup a password for your user **before** rebooting. Run `sudo nixos-enter --root /mnt -c 'passwd <username>'` to set the password.

Finally, you can reboot into your system! Once booted in, your existing `/nix-config` directory during the live boot should be accessible - you can delete this. Refactor to use colmena instead of standard flakes, test it and push up to the origin.

*More automation potential here - https://github.com/zhaofengli/colmena/issues/42#issuecomment-1004528027*


### Virtual Machines
It is best practice to keep vm flakes seperate from the host. This ensures rebuilding the host doesn't take too long or hog resources. Once we have a good CI/CD setup (argo workflows), we will automated the following steps.

To create a vm for the first time run:
```bash
sudo mkdir -p /mnt/zpool_ssd/microvms # Create .img directory
sudo chown -R microvm:kvm /mnt/zpool_ssd/microvms # Give kvm group and microvm user ownership
sudo chmod -R 777 /mnt/zpool_ssd/microvms
sudo microvm -f git+file:///home/bhamm/nix-config -c k3s-server-1
# Could do flake update/colmena apply w/ this github:blake-hamm/nix-config?dir=packages/laptop-charger (only when k3s secret figured out in agenix)
sudo systemctl start microvm@k3s-server-1
```

`microvm.autostart` will ensure the microvm always starts up.


To update and reboot a vm run (normally what you need to do):
```bash
sudo microvm -Ru k3s-server-1
sudo systemctl restart microvm@k3s-server-1 # Sometimes you need to run this
```

To remove a VM, run:
```bash
sudo systemctl stop microvm@k3s-server-1
sudo rm -rf /var/lib/microvms/k3s-server-1
sudo rm /mnt/zpool_ssd/microvms/k3s-server-1.img
```


#### VM Troubleshooting
In case you need to access a vm, you can ssh into the host and then ssh into the vm:
`ssh bhamm@localhost -p 14185 -o StrictHostKeyChecking=no`

For troubleshooting a new vm, you can change `proto = "9p";` in the vm config and run the following command:
`sudo nix run .#nixosConfigurations.aorus-k3s-server-1.config.microvm.declaredRunner`

### k3s
First, setup the first server and ssh into. Then, you need to follow [these instructions](https://github.com/blake-hamm/k3s-config/blob/main/DEPLOY.md) to get the base cluster ready.

Once the cluster is ready, you can copy the kubectl config to your local. To view the file, run:
```bash
sudo cat /etc/rancher/k3s/k3s.yaml
```
and change the urls with your kube-vip url. Then, you should be able to view your cluster in your local.

Without agenix or nix sops setup, we need to take care to distribute our k3s token manually to each machine before setting up any additional nodes. Oncer the cluster us up and running, view the k3s token:
```bash
sudo cat /var/lib/rancher/k3s/server/token
```
Then, replace `my_token` in `./modules/k3s/k3s.nix` with the value of this token (only on the vm host machine). Then, you can start the rest of the nodes and they will join the cluster.


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

### SOPS
```bash
# generate new age key from private ssh key
 nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

# get a public key of ~/.config/sops/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```
