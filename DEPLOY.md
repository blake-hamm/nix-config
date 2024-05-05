# This file contains instructions to deploy config to machines

### Apply changest with flakes
**sudo nixos-rebuild switch --flake .#framework**


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
