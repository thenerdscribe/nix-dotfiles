{
  description = "ryanmorton system management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zennotes.url = "github:ZenNotes/zennotes";
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kew.url = "git+https://codeberg.org/ravachol/kew";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # niri = {
    #   url = "github:niri-wm/niri";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    # matugen = {
    #   url = "github:/InioX/Matugen";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
              system.defaults.NSGlobalDomain._HIHideMenuBar = false;
              system.defaults.dock.autohide = true;
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
                systemPath = [
                  "~/.config/composer/vendor/bin"
                ];
              };
              nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';
              system.stateVersion = 4;
              system.defaults.NSGlobalDomain._HIHideMenuBar = false;
              system.defaults.dock.autohide = true;
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
    };
}
