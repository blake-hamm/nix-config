{
  imports = [
    ./boot.nix
    ./config.nix
    ./user.nix
    ./network.nix
    ./ssh.nix
    # ./backups.nix # TODO: backup zpools
    ./terminal.nix
    ./git.nix
  ];
}
