{ inputs, username, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];
  home-manager.users.${username} = {
    imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
    catppuccin = {
      flavour = "mocha";
      accent = "sapphire";
    };
    xdg.enable = true;
  };
}
