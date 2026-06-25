{ pkgs, ... }:
{
  users.users.ryanmorton = {
    uid = 501;
    name = "ryanmorton";
    home = "/Users/ryanmorton";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

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

  system.stateVersion = 4;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;
  system.defaults.dock.autohide = true;
}
