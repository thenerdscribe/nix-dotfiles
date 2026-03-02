# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Add hypridle

  nix.settings.download-buffer-size = 524288000;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    wifi = {
      scanRandMacAddress = true;
      powersave = true;
    };
  };
  networking.extraHosts = ''
    54.71.90.183   inventory-api.walts.com
    54.71.90.183   listingmanager.walts.com
    54.71.90.183    phpadmin-production.walts.com
    34.216.166.84   phpadmin.walts.com php test-retail-inventory-api.walts.com test-retail-api-ospos.walts.com test-retail-ordermanager.walts.com test-ordermanager.walts.com test-inventory-api.walts.com test-api-ospos.walts.com test-listingmanager.walts.com
    127.0.0.1 neo-tools.dev.walts.com awesome-ecomm.dev.walts.com inventory-api.dev.walts.com api-ospos.dev.walts.com gaming-schedule.test ordermanager.dev.walts.com forma-planner.test neo-pos1.dev.walts.com
    50.112.66.233 test-www.walts.com 
    35.160.43.43 test-neo-pos1.walts.com test-retail-neo-pos1.walts.com
    35.87.153.218 test-neo-wpos2.walts.com test-retail-neo-wpos2.walts.com
    35.90.134.222           ae-staging.walts.com
    54.149.169.134  commerce-1-admin.walts.com
  '';

  services.tailscale.enable = true;
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        extraConfig = ''
           # Make Apple keyboards work the same way on KDE as they do on MacOS
          [main]
          # Bind both "Cmd" keys to trigger the 'meta_mac' layer
          leftmeta = layer(meta_mac)
          rightmeta = layer(meta_mac)
        '';
      };
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  users.defaultUserShell = pkgs.zsh;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;
  services.displayManager.sddm.wayland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.xwayland.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ryanm = {
    isNormalUser = true;
    description = "Ryan Morton";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      sbctl
      ghostty
      os-prober
      kitty
      rofi
      gh
      inputs.matugen.packages.${system}.default
      inputs.quickshell.packages.${system}.default
      (import ../../scripts/create-product-issues-script.nix { inherit pkgs; })
      (import ../../scripts/create-dev-environment.nix { inherit pkgs; })
      (import ../../scripts/switch-audio.nix { inherit pkgs; })
    ];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  security.polkit.enable = true; # polkit
  programs.niri.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    docker-compose
    xwayland-satellite
    swww
    inputs.awww.packages.${pkgs.system}.awww
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    libuv
    openssl
    http-parser
    icu
    bash
    sqlite
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  hardware.keyboard.qmk.enable = true;

  services.caddy = {
    enable = true;
    virtualHosts."http://awesome-ecomm.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8889 
    '';
    virtualHosts."http://neo-tools.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8888
    '';
    virtualHosts."http://inventory-api.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8890
    '';
    virtualHosts."http://api-ospos.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8891 
    '';
    virtualHosts."http://gaming-schedule.test".extraConfig = ''
      reverse_proxy 127.0.0.1:8892 
    '';
    virtualHosts."http://ordermanager.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8893 
    '';
    virtualHosts."http://forma-planner.test".extraConfig = ''
      reverse_proxy 127.0.0.1:8894
    '';
    virtualHosts."http://neo-pos1.dev.walts.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8895
    '';
  };

  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04D8", ATTRS{idProduct}=="eb52", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c4", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c5", TAG+="uaccess"
  '';

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
  };
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri"; # Or "hyprland" or "sway"
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.hardware.openrgb.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
