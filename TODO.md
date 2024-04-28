# To do
x Borgmatic backup of ~/ (aka - latest backup)
x Setup start config with flakes + home manager (https://github.com/Misterio77/nix-starter-configs)
x Test home manager with catpuccin theme (https://github.com/catppuccin/nix)
x Refactor nix structure (modules, hosts, users)
x Add nix linter/formatter and remove ansible pre-commit
x Firefox
x Finalize catpuccin config (gnome, kitty, vscode)
x Add Nix discovery tools (https://github.com/nix-community/awesome-nix?tab=readme-ov-file#discovery)
x Setup backups (borgmatic + systemd)
- Deploy k3s cluster on framework with nix
- Refactor profile and network config with `hostConfig` dictionary
- Build minimal iso image with ssh
- Finalize laptop server nixos cluster
- Finalize k3s
- Get argo up on k3s
- Create CEPH cluster for persistent volumes (rook)
- Setup storage server with nixos (temp move data to CEPH)
- Orchestrate changes to all machine with colemna (https://github.com/zhaofengli/colmena)

## At this point I should have:
- NixOS config with security and backups
- NixOS on all machines with changes propogated from my framework with colemna
- CEPH and NFS storage available securely on network
- k3s dev running with basic apps

## Next steps after are:
- Run home manager command (without sudo)
- Automated CI/CD with argo events/workflows + colemna connected to SCM
    - Touchless deployment where: PR deploys to dev, merge to main deploys to prod
- Deploy vault and refactor more securely
- Make "prod" k3s
- Local and global (cloudflare) dns
- More k3s apps with middleware
- Wireguard setup
- Setup fingerprint

# Keep in mind
- For now, document manual deployment (cli) steps