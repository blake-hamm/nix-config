{ pkgs, inputs, username, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home manager universal config
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      programs.home-manager.enable = true;
    };
  };

  # Nixos user config
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nix.settings.allowed-users = [ "${username}" ];
}
