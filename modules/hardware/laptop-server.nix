{ system, inputs, ... }:
{
  services.logind.lidSwitch = "ignore";

  # Laptop charger poetry2nix app in packages/laptop-charger
  environment.systemPackages = with pkgs; [
    inputs.manage_charger.packages."${system}".manage_charger
  ];
}
