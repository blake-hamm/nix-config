{
  description = "Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Themes
    catppuccin.url = "github:catppuccin/nix";

    # MicroVM
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
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
            inherit self inputs username;
          };
          nodeSpecialArgs.framework = {
            host = "framework";
          };
          nodeSpecialArgs.aorus = {
            host = "aorus";
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
      };

      # VM and iso configs without colmena
      nixosConfigurations =
        let
          pkgs = inputs.nixpkgs;
          k3sVMs = import ./modules/k3s { inherit system inputs pkgs username; };

          # k3s VM config
          k3sVMConfigFramework = k3sVMs.buildConfig {
            vm_host = "framework";
            kube_vip = "192.168.69.19";
            # static_ip_start = ""; # TODO: Configure static ip more dynamically
            n = 1;
          };
          k3sVMConfigAorus = k3sVMs.buildConfig {
            vm_host = "aorus";
            kube_vip = "192.168.69.20";
            n = 1;
          };

          # All other config
          otherConfig = {
            # ISO image
            minimal-iso = nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                (import ./hosts/iso)
              ];
              specialArgs = {
                host = "minimal-iso";
                inherit self inputs username;
              };
            };
          };
        in
        # Combine config together
        k3sVMConfigFramework // k3sVMConfigAorus // otherConfig;

    };
}
