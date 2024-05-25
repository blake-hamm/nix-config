{ pkgs, inputs, system, host, username, ... }:
{
  services.logind.lidSwitch = "ignore";

  # Laptop charger poetry2nix app in packages/laptop-charger
  systemd = {
    timers."manage_charger" = {
      timerConfig = {
        OnBootSec = "5s";
        OnUnitActiveSec = "30m";
        Persistent = true;
        Unit = "manage_charger.service";
      };
      after = [ "timers.target" ];
    };
    services."manage_charger" = {
      path = with pkgs; [
        inputs.manage_charger.packages."${system}".manage_charger
      ];
      script = ''
        manage_charger --plug-alias ${host}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
