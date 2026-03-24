{ self, inputs, ... }:
{
  flake.nixosModules.nixosConfig =
    { pkgs, lib, ... }:
    {

      nixpkgs.overlays = [
        inputs.niri.overlays.default
      ];

      imports = [
        self.nixosModules.nixosHardware
        inputs.niri-flake.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
        inputs.zen-browser.homeModules.twilight
        inputs.walker.homeManagerModules.default
      ];

      programs.gtk = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font Light";
          size = 10;
        };
        theme = {
          name = "Fluent-Dark";
          package = pkgs.fluent-gtk-theme;
        };
        iconTheme = {
          name = "Fluent-Dark";
          package = pkgs.fluent-icon-theme;
        };
      };

      programs.dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      programs.zen-browser = {
        enable = true;
        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          # find more options here: https://mozilla.github.io/policy-templates/
        };
      };

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
          scanRandMacAddress = false;
          powersave = false;
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

      time.timeZone = "America/Phoenix";
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

      services.xserver.enable = false;
      services.displayManager.sddm.wayland.enable = true;

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
          sbctl
          ghostty
          os-prober
          kitty
          rofi
          gh
          git
          inputs.matugen.packages.${system}.default
          inputs.quickshell.packages.${system}.default
          (python313.withPackages (
            p: with p; [
              pandas
              requests
            ]
          ))
          sqlite
          _1password-cli
          vicinae
          go
          curl
          less
          nh
          ffmpeg_7-full
          poppler
          prettyping
          redis
          tailscale
          gh
          tree
          delta
          magic-wormhole
          yazi-unwrapped
          pcmanfm
          xarchiver
          gimp2-with-plugins
          ripgrep-all
          tableplus
          imagemagick
          pup
          gum
          font-awesome
          slack
          discord
          spotify
          lnav
          _1password-gui
          sqlite
          playerctl
          obsidian
          signal-desktop
          zellij
          magnetic-catppuccin-gtk
          distrobox
          cliphist
          ueberzugpp
          resvg
          imagemagick
          file
          cava
          libnotify
          smartmontools
          fluent-gtk-theme
          fluent-icon-theme
          audacious
          rustdesk-flutter
          inkscape-with-extensions
          scribus
          sushi
          cheese
          swaynotificationcenter
          pavucontrol
          cmus
          qobuz-player
          dconf
          streamdeck-ui
          libsecret
          pulseaudio
          wezterm
          chromium
          ghostty
          termusic
          wf-recorder
          openrgb-with-all-plugins
          wget
          wlogout
          postman
          syncthing
          realvnc-vnc-viewer
          unzip
          alacritty
          fuzzel
          xwayland-satellite
          vial
          via
          supersonic-wayland
          ollama-vulkan
          inotify-tools

          # (import ../../features/scripts/create-product-issues-script.nix { inherit pkgs; })
          # (import ../../features/scripts/create-dev-environment.nix { inherit pkgs; })
          # (import ../../features/scripts/switch-audio.nix { inherit pkgs; })
        ];

        sessionVariables = {
          XDG_CURRENT_DESKTOP = "niri";
          QT_QPA_PLATFORMTHEME = "gtk3";
          QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
          GTK_THEME = "Fluent-Dark";
          GTK_USE_PORTAL = "1";
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          #DISPLAY = ":0";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "niri";
          GOPATH = "/home/ryanm/go";
          PHP_CS_FIXER_IGNORE_ENV = 1;
          EDITOR = "nvim";
          FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git --reverse --height=10";
          FZF_CTRL_T_OPTS = ''
            --walker-skip .git,node_modules,target \
            --preview 'bat -n --color=always {}' \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' '';
          FZF_CTRL_R_OPTS = ''
            --preview 'echo {}' --preview-window up:3:hidden:wrap \
                        --bind 'ctrl-/:toggle-preview' \
                        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
                        --color header:italic \
                        --header 'Press CTRL-Y to copy command into clipboard' '';
          FZF_ALT_C_OPTS = ''
            --walker-skip .git,node_modules,target \
            --preview 'tree -C {}' '';
          HISTFILE = "~/.zsh_history";
          HISTSIZE = "100000";
          SAVEHIST = "100000";
        };
      };

      programs = {
        zoxide.enable = true;
        ripgrep.enable = true;
        fd.enable = true;
        btop.enable = true;
        jq.enable = true;
        lazygit.enable = true;
        bat = {
          enable = true;
          config = {
            theme = "Catppuccin Mocha"; # Fix this for bat
          };
          themes = {
            "Catppuccin Mocha" = {
              src = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "bat";
                rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
                sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
              };
              file = "themes/Catppuccin Mocha.tmTheme";
            };
          };
        };
        eza = {
          enable = true;
        };
        git = {
          enable = true;
        };
        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        zsh = {
          enable = true;
          enableCompletion = true;
          autocd = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          plugins = [
            {
              name = "vi-mode";
              src = pkgs.zsh-vi-mode;
              file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
            }
          ];
          shellAliases = {
            ssh = "TERM='xterm' ssh";
            vim = "nvim";
            pbc = "pbcopy";
            pbp = "pbpaste";
            c = "clear";
            zwl = "zellij -l welcome";
            zkl = "zellij kill-all-sessions -y; zellij delete-all-sessions -y";
            ls = "eza --icons --color=always";
            la = "ls -a";
            ll = "ls -al";
            cat = "bat";
            ql = "qlmanage -p";
            pu = "pushd";
            gcam = "git commit -am";
            gaa = "git add --all";
            gss = "git status -s";
            gd = "git diff";
            gp = "git push";
            gl = "git pull";
            gco = "git checkout";
            gsta = "git stash";
            gstaa = "git stash apply";
            gcm = "git checkout master";
            grb = "git rebase";
            gb = "git branch";
            # composer = "valet composer";
            # php = "valet php";
            art = "php artisan";
            stress = "./vendor/bin/pest stress";
            zlss = "zellij list-sessions --no-formatting --short";
            zls = "zellij list-sessions";
            wbp = "wl-paste";
            wbc = "wl-copy";
          };
          initContent = ''
            function za () {
                local sessions="$(zellij list-sessions --no-formatting --short)"
                if [ -z $sessions ]
                then
                    return;
                fi
                if [ -z $1 ]; then
                    local session="$(echo $sessions | fzf)";
                else 
                    local session="$(echo $sessions | fzf --select-1 -q $1)";
                fi
                zellij attach $session
            };
            setopt autopushd
            function my_init() {
              bindkey '^ ' autosuggest-accept
              [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
              export KEYTIMEOUT=2
              bindkey -r '^R'
              bindkey -r '^G'
              source "$(fzf-share)/key-bindings.zsh"
              source "$(fzf-share)/completion.zsh"
              [ -f ~/.config/fzf/fzf-git.sh ] && source ~/.config/fzf/fzf-git.sh
            }
            zvm_after_init_commands+=(my_init)
          '';
        };
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
            add_newline = true;
            format = ''
              $username $directory $git_branch$git_status $nix_shell
              $character 
            '';
            directory = {
              style = "fg:#8bd5ca";
              format = "[$path]($style)";
              truncation_length = 3;
              truncation_symbol = "…/";
              substitutions = {
                Documents = "󰈙 ";
                Downloads = " ";
                Music = " ";
                Pictures = " ";
              };
            };
            username = {
              show_always = true;
              style_user = "fg:#8aadf4";
              format = "[󰿘 ]($style)";
            };
            git_branch = {
              symbol = "";
              style = "fg:#f0c6c6";
              format = "[$symbol $branch]($style)";
            };
            git_status = {
              style = "fg:#ed8796";
              format = "[$all_status$ahead_behind]($style)";
            };
            character = {
              format = "[$symbol](bg: #45475a)";
              vimcmd_symbol = "[ ](fg:#eed49f)";
              success_symbol = "[ ](fg:#a6da95)";
              error_symbol = "[ ](fg:#ed8796)";
              vimcmd_replace_symbol = "[R](fg:#dbbc7f)";
              vimcmd_replace_one_symbol = "[RO](fg:#dbbc7f)";
              vimcmd_visual_symbol = "[V](fg:#dbbc7f)";
            };
            nix_shell = {
              symbol = " ";
              format = "[$symbol]($style)";
              style = "fg:#eed49f";
              impure_msg = "(I)";
              pure_msg = "(P)";
              unknown_msg = "";
              heuristic = false;
            };
            time = {
              disabled = true;
              time_format = "%r"; # Hour:Minute Format
              style = "bg:#74c7ec";
              format = "[ ♥ $time ]($style)";
            };
          };
        };
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
        dank-material-shell = {
          enable = true;
          niri.enableSpawn = true;
          niri.includes = {
            enable = true; # Enable config includes hack. Enabled by default.
            override = false; # If disabled, DMS settings won't be prioritized over settings defined using niri-flake
            originalFileName = "hm"; # A new name (without extension) for the config file generated by niri-flake.
            filesToInclude = [
              # Files under `$XDG_CONFIG_HOME/niri/dms` to be included into the new config
              "blur"
              "alttab" # Please note that niri will throw an error if any of these files are missing.
              "binds"
              "colors"
              "layout"
              "outputs"
              "wpblur"
            ];
          };
        };
      };

      security.polkit.enable = true; # polkit

      # Install firefox.
      programs.firefox.enable = true;

      environment.systemPackages = with pkgs; [
        wl-clipboard
        docker-compose
        xwayland-satellite
        swww
        inputs.awww.packages.${pkgs.system}.awww
        git
        delta
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
      services.displayManager.ly.enable = true;

      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="04D8", ATTRS{idProduct}=="eb52", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c4", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a3c5", TAG+="uaccess"
      '';

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

    };
}
