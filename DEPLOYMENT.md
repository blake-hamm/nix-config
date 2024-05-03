# This file contains instructions to deploy config to machines

### Apply changest with flakes
**sudo nixos-rebuild switch --flake .#framework**


### k3s
To deploy k3s, add the module in `metal/k3s.nix`. To remove, remove this module *and* folow the directions [here](https://kube-vip.io/docs/usage/k3s/#clean-environment) to remove k3s on your system.


### Virtual Machines
It is best practice to keep vm flakes seperate from the host. This ensures rebuilds on the host don't take longer than necessary. Once we have a good CI/CD setup (argo workflows), we will automated the following steps.

To create a vm for the first time run:
`sudo microvm -f git+file:///home/bhamm/Documents/repos/nix-config -c my-microvm`

After the vm is created and `microvm.autostart` is configured, it will automatically start on the next rebuild.

To update and reboot a vm run (normally what you need to do):
`sudo microvm -Ru my-microvm`


#### VM Troubleshooting
In case you need to access a vm, you can ssh into the host and then ssh into the vm:
`ssh bhamm@localhost -p 44185`
For troubleshooting a new vm, you can change `proto = "9p";` in the vm config and run the following command:
`sudo nix run .#my-microvm`
