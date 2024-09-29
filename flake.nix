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
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
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
                loginShell = pkgs.zsh;
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

      darwinConfigurations.Ryans-Mac-Mini = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
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
                loginShell = pkgs.zsh;
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
    };
}
