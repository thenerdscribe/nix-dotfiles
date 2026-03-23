{ self, inputs, ... }:
{
  flake.nixosConfigurations.air = inputs.nixpkgs.lib.nixosSystem {
    modules = [
    ];
  };
}
