# This file contains instructions to deploy config to machines

### Apply changest with flakes
**sudo nixos-rebuild switch --flake .#framework**


### Virtual Machines
It is best practice to keep vm flakes seperate from the host. This ensures rebuilding the host doesn't take too long or hog resources. Once we have a good CI/CD setup (argo workflows), we will automated the following steps.

To create a vm for the first time run:
`sudo microvm -f git+file:///home/bhamm/Documents/repos/nix-config -c framework-vm-k3s-server-1`

After the vm is created and `microvm.autostart` is configured, it will automatically start on the next rebuild.

To update and reboot a vm run (normally what you need to do):
`sudo microvm -Ru framework-vm-k3s-server-1`

To remove a VM, run:
`sudo rm -rf /var/lib/microvms/framework-vm-k3s-server-1`


#### VM Troubleshooting
In case you need to access a vm, you can ssh into the host and then ssh into the vm:
`ssh bhamm@localhost -p 44185`
For troubleshooting a new vm, you can change `proto = "9p";` in the vm config and run the following command:
`sudo nix run .#my-microvm`
