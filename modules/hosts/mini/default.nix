{ self, inputs, ... }:
{
  flake.nixosConfigurations.mini = inputs.nixpkgs.lib.nixosSystem {
    modules = [
    ];
  };
}
