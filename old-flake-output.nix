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
}
