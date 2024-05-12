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
            targetPort = 4185;
          };
          imports = [ ./hosts/framework ];
        };

        aorus = { name, nodes, pkgs, ... }: {
          deployment = {
            tags = [ "aorus" "server" ];
            targetUser = "${username}";
            targetHost = "192.168.69.12";
            targetPort = 4185;
          };
          imports = [ ./hosts/aorus ];
        };
      };

      # VM and iso configs without colmena
      nixosConfigurations = {

        # VM
        # framework-vm-k3s-server-1 = nixpkgs.lib.nixosSystem {
        #   inherit system;
        #   modules = [ (import ./hosts/k3s-server) ];
        #   specialArgs = {
        #     host_ssh_port = 14185;
        #     host = "framework-vm-k3s-server-1";
        #     inherit self inputs username;
        #   };
        # };
        aorus-k3s-server-1 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/k3s-server) ];
          specialArgs = {
            host = "aorus-k3s-server-1";
            inherit self inputs username;
          };
        };


        # iso
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
    };
}
