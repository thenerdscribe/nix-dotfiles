{
  description = "ryanmorton system management";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      ghostty,
      ...
    }:
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
                  ghostty.packages.x86_64-darwin
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

      darwinConfigurations.Ryans-Mac-Mini = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
          config = {
            allowUnfree = true;
            allowUnfreePredicate = true;
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
              networking.hosts = {
                "127.0.0.1" = [
                  "localhost"
                  "ordermanager.dev.walts.com"
                  "api-ospos.dev.walts.com"
                  "inventory-api.dev.walts.com"
                  "listing-manager.dev.walts.com"
                  "neo-tools.dev.walts.com"
                  "neo-pos1.dev.walts.com"
                  "awesome-ecomm.dev.walts.com"
                  ".dev.walts.com"
                ];
                "54.71.90.183" = [
                  "inventory-api.walts.com"
                  "phpadmin.walts.com"
                  "phpadmin-production.walts.com"
                ];
                "34.216.166.84" = [
                  "phpadmin.walts.com"
                  "test-retail-inventory-api.walts.com"
                  "test-retail-api-ospos.walts.com"
                  "test-retail-ordermanager.walts.com"
                  "test-ordermanager.walts.com"
                  "test-inventory-api.walts.com"
                  "test-api-ospos.walts.com"
                  "test-listingmanager.walts.com"
                ];
                "50.112.66.233" = [ "test-www.walts.com" ];
                "35.160.43.43" = [
                  "test-neo-pos1.walts.com"
                  "test-retail-neo-pos1.walts.com"
                ];
                "35.87.153.218" = [
                  "test-neo-wpos2.walts.com"
                  "test-retail-neo-wpos2.walts.com"
                ];
                "35.90.134.222" = [ "ae-staging.walts.com" ];
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
