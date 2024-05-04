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
      # Enable microvm self runner
      # packages.${system} = {
      #   default = self.packages.${system}.my-microvm;
      #   my-microvm = self.nixosConfigurations.my-microvm.config.microvm.declaredRunner;
      # };

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
            host = "framework-vm-k3s-server-1";
            inherit self inputs username;
          };
        };
      };
    };
}
