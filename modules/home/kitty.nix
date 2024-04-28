{ inputs, username, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.${username} = {
    programs.kitty = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
