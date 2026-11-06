{
  description = "ryanmorton system management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs_darwin_2026.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    zennotes.url = "github:ZenNotes/zennotes";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    dms = {
      url = "github:duxlabs-dev/dux-shell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dfiles = {
      url = "github:duxlabs-dev/dux-files";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dcalendar = {
      url = "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tether = {
      url = "github:zackb/tether";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake.nix
    mangowm = {
      # url = "github:mangowm/mango/wl-only";
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin-home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs_darwin_2026";
    };
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs_darwin_2026";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs_darwin_2026,
      darwin,
      home-manager,
      darwin-home-manager,
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
          (
            { pkgs, ... }:
            {
              users.users.ryanmorton = {
                uid = 501;
                name = "ryanmorton";
                home = "/Users/ryanmorton";
                shell = pkgs.zsh;
              };
              programs.zsh.enable = true;
              # homebrew.enable = true;
              # homebrew.brews = [ ];
              environment = {
                shells = [
                  pkgs.bash
                  pkgs.zsh
                ];
                systemPackages = [
                  pkgs.coreutils
                  pkgs.git
                  pkgs.curl
                  pkgs.wget
                  pkgs.zellij
                  pkgs.jankyborders
                ];
              };
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';
              services.nix-daemon.enable = true;
              system.stateVersion = 4;
            }
          )
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ryanmorton.imports = [
                ./modules/home-manager
              ];
            };
          }
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
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
        specialArgs = {
          inherit inputs;
        };
        pkgs = import nixpkgs_darwin_2026 {
          system = "x86_64-darwin";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = true;
            allowBroken = true;
          };
        };
        modules = [
          darwin-home-manager.darwinModules.home-manager
          ./modules/systems/mini/configuration.nix
          ./modules/systems/mini/home.nix
        ];
      };
    };
}
