# This file contains instructions to deploy config to machines

## Apply local changes with flakes
**sudo nixos-rebuild switch --flake .#framework**


## Setup new machine
### Build and flash iso image
*NOTE: This only creates a live iso image with my minimal configuration, to automate the full install, we need to checkout disco and create some kind of sccript like https://haseebmajid.dev/posts/2024-02-04-how-to-create-a-custom-nixos-iso/*
```bash
nix build .#nixosConfigurations.minimal-iso.config.system.build.isoImage
dd if=result/iso/*.iso of=/dev/sdX status=progress
sync
```
### Boot from libe iso
Once booted into your live environment, you need to manually setup the network following the official docs - https://nixos.org/manual/nixos/stable/index.html#sec-installation. If you have ethernet, you can skip this.

Next, you should be able to ssh into your live environment. Find the ip address and ssh into it with your user.

Now, you will want to view the device id's. Find the device with `lsblk` and find the id with `udevadm info /dev/sdX`. Once you have this info, construct your disko config and push to the repo.

Next, you need to put your hardware config into your git project. To generate a hardware config, run `nixos-generate-config --no-filesystems --root /mnt/nix-config` and move it to the propper folder.

After your disko config is finalized, clone this repo to `/mnt/nix-config` and install with `sudo nixos-install  --no-root-passwd --flake /mnt/nix-config#the-machine`. This will prompt you to enter a root password.

Finally, boot into your new system and login to root. Once logged in, set your user password with `passwd <username>`. Then, you can add `users.users.root.hashedPassword = "!";` to your config to disable root user!


### Virtual Machines
It is best practice to keep vm flakes seperate from the host. This ensures rebuilding the host doesn't take too long or hog resources. Once we have a good CI/CD setup (argo workflows), we will automated the following steps.

To create a vm for the first time run:
```bash
sudo microvm -f git+file:///home/bhamm/repos/nix-config -c framework-vm-k3s-server-1
sudo systemctl start microvm@framework-vm-k3s-server-1.service
```

`microvm.autostart` will ensure the microvm always starts up.


To update and reboot a vm run (normally what you need to do):
`sudo microvm -Ru framework-vm-k3s-server-1`

To remove a VM, run:
```bash
sudo systemctl stop microvm@framework-vm-k3s-server-1.service
sudo rm -rf /var/lib/microvms/framework-vm-k3s-server-1
```


#### VM Troubleshooting
In case you need to access a vm, you can ssh into the host and then ssh into the vm:
`ssh bhamm@localhost -p 14185 -o StrictHostKeyChecking=no`

For troubleshooting a new vm, you can change `proto = "9p";` in the vm config and run the following command:
`sudo nix run .#framework-vm-k3s-server-1`
