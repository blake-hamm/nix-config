{
  description = "Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Themes
    catppuccin.url = "github:catppuccin/nix";

    # MicroVM
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # laptop-charger (in packages dir)
    manage_charger = {
      url = "github:blake-hamm/nix-config?dir=packages/laptop-charger";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, self, ... } @ inputs:
    let
      username = "bhamm";
      system = "x86_64-linux";
      sshPort = 4185;
    in
    {
      # Bare metal
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            inherit system;
          };
          specialArgs = {
            inherit self inputs username system;
          };
          nodeSpecialArgs.framework = {
            host = "framework";
          };
          nodeSpecialArgs.aorus = {
            host = "aorus";
          };
          nodeSpecialArgs.precision = {
            host = "precision";
          };
        };

        framework = { name, nodes, pkgs, ... }: {
          deployment = {
            allowLocalDeployment = true;
            tags = [ "framework" "local" "desktop" ];
            targetUser = "${username}";
            targetHost = "localhost";
            targetPort = sshPort;
          };
          imports = [ ./hosts/framework ];
        };

        aorus = { name, nodes, pkgs, ... }: {
          deployment = {
            tags = [ "aorus" "server" ];
            targetUser = "${username}";
            targetHost = "192.168.69.12";
            targetPort = sshPort;
          };
          imports = [ ./hosts/aorus ];
        };

        precision = { name, nodes, pkgs, ... }: {
          deployment = {
            tags = [ "precision" "server" ];
            targetUser = "${username}";
            targetHost = "192.168.69.13";
            targetPort = sshPort;
          };
          imports = [ ./hosts/precision ];
        };
      };

      # VM and iso configs without colmena
      nixosConfigurations =
        let
          pkgs = inputs.nixpkgs;
          k3sVMs = import ./modules/k3s { inherit system inputs pkgs username; };

          # k3s VM config
          k3sServerVMConfig = k3sVMs.buildConfig {
            kube_vip = "192.168.69.20";
            k3s_role = "server";
            n = 3;
          };
          k3sAgentVMConfig = k3sVMs.buildConfig {
            kube_vip = "192.168.69.20";
            k3s_role = "agent";
            n = 3;
          };

          # All other config
          otherConfig = {
            # ISO image
            minimal-iso = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                (import ./hosts/iso)
                {
                  nixpkgs.config.allowBroken = true;
                }
              ];
              specialArgs = {
                host = "minimal-iso";
                inherit self inputs username;
              };
            };
            # elitebook example
            elitebook = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                (import ./hosts/elitebook)
              ];
              specialArgs = {
                host = "elitebook";
                inherit self inputs username;
              };
            };
          };
        in
        # Combine config together
        k3sServerVMConfig // k3sAgentVMConfig // otherConfig;

    };
}
