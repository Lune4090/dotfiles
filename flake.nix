{
  description = "Lune's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Collection for Hardware setting
    xremap.url = "github:xremap/nix-flake";
    home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs@{ self, home-manager, rust-overlay, ...}: {
    nixosConfigurations = {
      SV7 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./starship.nix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            environment.systemPackages = with pkgs; [ 
              rust-bin.stable.latest.default
            ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lune = import ./home.nix;
          }
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
