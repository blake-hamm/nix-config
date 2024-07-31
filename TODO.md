# To do
 - [x] Borgmatic backup of ~/ (aka - latest backup)
 - [x] Setup start config with flakes + home manager (https://github.com/Misterio77/nix-starter-configs)
 - [x] Test home manager with catpuccin theme (https://github.com/catppuccin/nix)
 - [x] Refactor nix structure (modules, hosts, users)
 - [x] Add nix linter/formatter and remove ansible pre-commit
 - [x] Firefox
 - [x] Finalize catpuccin config (gnome, kitty, vscode)
 - [x] Add Nix discovery tools (https://github.com/nix-community/awesome-nix?tab=readme-ov-file#discovery)
 - [x] Setup backups (borgmatic + systemd)
 - [x] Deploy k3s cluster on framework with nix
 - [x] Use disko to manage discs
 - [x] Setup colemna locally
 - [x] Setup colemna with storage host (aorus)
 - [x] Finalize aorus + colemna + disk
 - [x] Refactor profile and network config
 - [x] Build minimal iso image with ssh
 - [x] Finalize nas (x2)
 - [x] Automate k3s node deployment with nix functional approach
 - [x] Setup precision laptop
  - [x] Laptop charging script systemd
  - [x] Laptop screen close
 - [ ] Finalize 3 node k3s with token and serverAddr
 - [x] Create NFS for persistent volume
 - [ ] Use vault secrets for ssh port and ip 192.168.X value
 - [ ] Use vault for ssh (?)
 - [ ] Vault is used for all secrets

## At this point I should have:
- [x] NixOS config with security and backups
- [x] NixOS on all machines
- [x] NFS storage available securely on network
- [x] k3s running with basic apps

## Next steps after are:
 - [ ] Bastion host - https://astro.github.io/microvm.nix/ssh-deploy.html
 - [ ] Run home manager command (without sudo)
 - [ ] Automated CI/CD with argo events/workflows connected to SCM (monorepo)
   - [ ] Touchless deployment where: PR deploys to dev, merge to main deploys to prod
 - [ ] Global (cloudflare) dns - refactor project to url's
 - [ ] Wireguard setup
 - [ ] Setup fingerprint
 - [ ] Finalize laptop server nixos cluster
 - [ ] Try hyperland

## Stretch tasks:
 - [ ] Create nixos router
    - https://github.com/chayleaf/nixos-router
    - https://discourse.nixos.org/t/guide-to-nixos-based-router-2023-part-2-software/35727
    - Many more examples on duckduckgo search
 - [ ] Leverage VLANs
 - [ ] Switch to snapraid + mergerfs for sata ssd pool and more storage

# Keep in mind
- For now, document manual deployment (cli) steps
- Is there a way to template out colmena, nixosConfigurations and homeManager all in one go? Then, I have multiple options to run the same thing? Or, can I just use colmena for everything and I just need to sort out the cli commands to create an image/deploy microvm?

*At some point, let's refactor nix-config and k3s-config into a monorepo.*
  - Once a monorepo is sorted, let's automate a cluster deployment to k3s machines
