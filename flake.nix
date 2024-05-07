{
  description = "Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

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
      # TODO: Define hostConfig dictionary with:
      # system, profile, ip
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {

        framework = lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/framework) ];
          specialArgs = {
            host = "framework";
            inherit self inputs username;
          };
        };

        framework-vm-k3s-server-1 = lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/k3s-server) ];
          specialArgs = {
            host_ssh_port = 14185;
            host = "framework-vm-k3s-server-1";
            inherit self inputs username;
          };
        };

        minimal-iso = lib.nixosSystem {
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            (import ./modules/profiles/minimal.nix)
          ];
          specialArgs = {
            host = "minimal-iso";
            inherit self inputs username;
          };
        };

      };
    };
}
