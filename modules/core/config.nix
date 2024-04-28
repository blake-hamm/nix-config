{ inputs, username, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Home manager config
  home-manager.users.${username} = {
    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "23.11";
  };

  # Other system config
  services.printing.enable = true;
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.11";
}
