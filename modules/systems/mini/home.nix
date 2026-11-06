{ pkgs, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.ryanmorton = {
      home.stateVersion = "24.11";
      imports = [
        ../../applications/neovim
        ../../applications/shell
        # ../../applications/zen
      ];
      home.packages = with pkgs; [
        delta
      ];
    };
  };
}
