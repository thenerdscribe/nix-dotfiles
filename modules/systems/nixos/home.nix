{ pkgs, inputs, ... }:
let
  sweet = pkgs.callPackage ./sweet.nix { inherit pkgs; };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.ryanm =
      {
        pkgs,
        lib,
        config,
        stdenv,
        inputs,
        ...
      }:
      {
        home.stateVersion = "25.11";

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          config.common.default = "gnome";
          config.mango = {
            default = [
              "wlr"
              "gtk"
            ];
          };
        };

        imports = [
          inputs.dms.homeModules.dank-material-shell
          inputs.dcalendar.homeModules.dank-calendar
          inputs.zen-browser.homeModules.twilight
          inputs.mangowm.hmModules.mango
          inputs.dfiles.homeModules.dux-files
          ./packages.nix
          ../../applications/mango
          ../../applications/neovim
          ../../applications/shell
          ../../applications/zen
          ../../features/dux
        ];

        services.mpd = {
          enable = true;
          musicDirectory = "~/Music";
          playlistDirectory = "/home/ryanm/Music";
          extraConfig = ''
            audio_output {
                type "pulse"
                name "My Default Output"
            }
            audio_output {
                type        "httpd"
                name        "mp3audio"
                encoder     "lame"
                port        "6969"
                bitrate     "320"
                format      "44100:16:2"
            }
            audio_output {
                type   "fifo"
                name   "my_fifo"
                path   "/tmp/mpd.fifo"
                format "44100:16:2"
            }
          '';
        };

        services.mpd-mpris = {
          enable = true;
        };

        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        };

        gtk = {
          enable = true;
          gtk3.theme = {
            name = "Sweet-Dark";
            package = sweet;
          };
          gtk4.theme = {
            name = "Sweet-Dark";
            package = sweet;
          };
          gtk4.iconTheme = {
            name = "Candy";
            package = pkgs.candy-icons;
          };
        };
      };

    extraSpecialArgs = {
      inherit inputs;
      stdenv.hostPlatform.system = "x86_64-linux";
    };
  };
}
