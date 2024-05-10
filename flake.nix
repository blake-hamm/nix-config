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
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            inherit system;
          };
          specialArgs = {
            inherit self inputs username;
          };
          nodeSpecialArgs.framework = {
            # TODO: Define hostConfig dictionary with:
            # system, profile, ip
            host = "framework";
          };
        };

        framework = { name, nodes, pkgs, ... }: {
          deployment = {
            allowLocalDeployment = true;
            tags = [ "local" "desktop" ];
            targetUser = "${username}";
          };
          imports = [ ./hosts/framework ];
        };
      };
      nixosConfigurations = {

        #   framework = lib.nixosSystem {
        #     inherit system;
        #     modules = [ (import ./hosts/framework) ];
        #     specialArgs = {
        #       host = "framework";
        #       inherit self inputs username;
        #     };
        #   };

        #   framework-vm-k3s-server-1 = lib.nixosSystem {
        #     inherit system;
        #     modules = [ (import ./hosts/k3s-server) ];
        #     specialArgs = {
        #       host_ssh_port = 14185;
        #       host = "framework-vm-k3s-server-1";
        #       inherit self inputs username;
        #     };
        #   };

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
