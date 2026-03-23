{ self, inputs, ... }:
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nixosConfig
      self.nixosModules.niri
    ];
  };
}
