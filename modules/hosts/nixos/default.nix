{ self, inputs, ... }:
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = true;
        allowBroken = true;
      };
    };
    modules = [
      self.nixosModules.nixosConfig
      self.nixosModules.niri
      self.nixosModules.neovim
    ];
  };
}
