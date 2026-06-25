{
  description = "ryanmorton system management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/blur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      zen-browser,
      ...
    }@inputs:
    {
      darwinConfigurations.Ryans-MacBook-Air = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
        modules = [
          ./modules/systems/darwin/configuration.nix
          ./modules/systems/darwin/macbook-air.nix
          home-manager.darwinModules.home-manager
          ./modules/systems/darwin/home.nix
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = true;
            allowBroken = true;
          };
        };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/systems/nixos/configuration.nix
          ./modules/systems/nixos/home.nix
        ];
      };

      darwinConfigurations.Ryans-Mac-Mini = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = true;
            allowBroken = true;
          };
        };
        modules = [
          ./modules/systems/darwin/configuration.nix
          ./modules/systems/darwin/mac-mini.nix
          home-manager.darwinModules.home-manager
          ./modules/systems/darwin/home.nix
        ];
      };
    };
}
