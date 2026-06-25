{ ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ryanmorton = {
      home.stateVersion = "25.11";
      imports = [
        ../../home-manager
      ];
    };
  };
}
