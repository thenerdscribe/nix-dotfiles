{ ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ryanmorton.imports = [
      ../../home-manager
    ];
  };
}
