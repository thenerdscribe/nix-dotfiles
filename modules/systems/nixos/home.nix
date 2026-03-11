{ pkgs, inputs, ... }:
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

        imports = [
          inputs.niri.homeModules.niri
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
          inputs.zen-browser.homeModules.twilight
          inputs.walker.homeManagerModules.default
          inputs.vicinae.homeManagerModules.default
        ];
        programs.niri.config = ''
          environment {
              XDG_CURRENT_DESKTOP "niri"
              QT_QPA_PLATFORM "wayland"
              ELECTRON_OZONE_PLATFORM_HINT "auto"
              QT_QPA_PLATFORMTHEME "gtk3"
              QT_QPA_PLATFORMTHEME_QT6 "gtk3"
          }
          output "HDMI-A-2" {
              scale 2.0
              position x=2560 y=-250
              transform "90"
          }
          output "DP-1" {
              variable-refresh-rate on-demand=true
              position x=0 y=0
              focus-at-startup
          }
          input {
              focus-follows-mouse max-scroll-amount="0%"
              keyboard {
                  numlock
              }
              touchpad {
                  // off
                  tap
                  // dwt
                  // dwtp
                  // drag false
                  // drag-lock
                  natural-scroll
                    // accel-speed 0.2
                  // accel-profile "flat"
                  // scroll-method "two-finger"
                  // disabled-on-external-mouse
              }
              mouse {
                  // off
                  // natural-scroll
                  // accel-speed 0.2
                  // accel-profile "flat"
                  // scroll-method "no-scroll"

              }
          }
          layout {
              gaps 16
              background-color "transparent"
              center-focused-column "never"
              preset-column-widths {
                  proportion 0.25
                  proportion 0.33333
                  proportion 0.5
                  proportion 0.66667
                  proportion 0.75
                  proportion 1.0
              }
              default-column-width {
                  proportion 0.5
              }
              focus-ring {
                  width 2
                  inactive-color "#505050"
                  active-gradient from="#80c8ff" to="#c7ff7f" angle=45
              }
              // You can also add a border. It's similar to the focus ring, but always visible.
              border {
                  off
              }
          }
          hotkey-overlay {
              skip-at-startup
          }
          prefer-no-csd
          screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
          animations {
          }
          window-rule {
              match app-id="^org\\.wezfurlong\\.wezterm$"
              default-column-width {

              }
          }
          // Open the Firefox picture-in-picture player as floating by default.
          window-rule {
              // This app-id regular expression will work for both:
              // - host Firefox (app-id is "firefox")
              // - Flatpak Firefox (app-id is "org.mozilla.firefox")
              match app-id="firefox$" title="^Picture-in-Picture$"
              open-floating true
          }
          window-rule {
              // This app-id regular expression will work for both:
              // - host Firefox (app-id is "firefox")
              // - Flatpak Firefox (app-id is "org.mozilla.firefox")
              match app-id="rofi$" title="Rofi"
              open-floating true
          }
          // Example: block out two password managers from screen capture.
          // (This example rule is commented out with a "/-" in front.)
          /-window-rule {
          match app-id=r#"^org\.keepassxc\.KeePassXC$"#
          match app-id=r#"^org\.gnome\.World\.Secrets$"#
          block-out-from "screen-capture"
          // Use this instead if you want them visible on third-party screenshot tools.
          // block-out-from "screencast"
          }
          // Example: enable rounded corners for all windows.
          // (This example rule is commented out with a "/-" in front.)
          window-rule {
              geometry-corner-radius 10
              clip-to-geometry true
          }
          binds {
              Mod+Shift+Slash {
                  show-hotkey-overlay
              }
              Mod+E hotkey-overlay-title="Open file manager: nautilus" {
                  spawn "nautilus"
              }
              Mod+T hotkey-overlay-title="Open a Terminal: ghostty" {
                  spawn "ghostty"
              }
              Mod+Space repeat=false hotkey-overlay-title="Vicinae (Raycast)" {
                  spawn "vicinae" "toggle"
              }
              Mod+Shift+Space repeat=false hotkey-overlay-title="DMS Spotlight" {
                  spawn "dms" "ipc" "call" "spotlight" "toggle"
              }
              Super+Alt+Shift+Ctrl+C hotkey-overlay-title="Clipboard history" {
                  spawn "vicinae" "vicinae://extensions/vicinae/clipboard/history"
              }
              XF86AudioRaiseVolume allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox volume 0.1+"
              }
              XF86AudioLowerVolume allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox volume 0.1-"
              }
              XF86AudioMute allow-when-locked=true {
                  spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              }
              XF86AudioMicMute allow-when-locked=true {
                  spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              }
              XF86AudioPlay allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox play-pause"
              }
              XF86AudioStop allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox stop"
              }
              XF86AudioPrev allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox previous"
              }
              XF86AudioNext allow-when-locked=true {
                  spawn-sh "playerctl --player=cmus,qobuz-player,spotify,Supersonic,audacious,firefox next"
              }
              Mod+O repeat=false {
                  toggle-overview
              }
              Mod+Q repeat=false {
                  close-window
              }
              Alt+H {
                  focus-column-left
              }
              Alt+J {
                  focus-window-down
              }
              Alt+K {
                  focus-window-up
              }
              Alt+L {
                  focus-column-right
              }
              Mod+Ctrl+Left {
                  move-column-left
              }
              Mod+Ctrl+Down {
                  move-window-down
              }
              Mod+Ctrl+Up {
                  move-window-up
              }
              Mod+Ctrl+Right {
                  move-column-right
              }
              Mod+Ctrl+H {
                  move-column-left
              }
              Mod+Ctrl+J {
                  move-window-down
              }
              Mod+Ctrl+K {
                  move-window-up
              }
              Mod+Ctrl+L {
                  move-column-right
              }
              Mod+Shift+H {
                  focus-monitor-left
              }
              Mod+Shift+L {
                  focus-monitor-right
              }
              Mod+Shift+Ctrl+H {
                  move-window-to-monitor-left
              }
              Mod+Shift+Ctrl+L {
                  move-window-to-monitor-right
              }
              Alt+U {
                  focus-workspace-down
              }
              Alt+I {
                  focus-workspace-up
              }
              Alt+Ctrl+U {
                  move-column-to-workspace-down
              }
              Alt+Ctrl+I {
                  move-column-to-workspace-up
              }
              Mod+Shift+U {
                  move-workspace-down
              }
              Mod+Shift+I {
                  move-workspace-up
              }
              Mod+WheelScrollDown cooldown-ms=150 {
                  focus-workspace-down
              }
              Mod+WheelScrollUp cooldown-ms=150 {
                  focus-workspace-up
              }
              Mod+Ctrl+WheelScrollDown cooldown-ms=150 {
                  move-column-to-workspace-down
              }
              Mod+Ctrl+WheelScrollUp cooldown-ms=150 {
                  move-column-to-workspace-up
              }
              Mod+WheelScrollRight {
                  focus-column-right
              }
              Mod+WheelScrollLeft {
                  focus-column-left
              }
              Mod+Ctrl+WheelScrollRight {
                  move-column-right
              }
              Mod+Ctrl+WheelScrollLeft {
                  move-column-left
              }
              Mod+Shift+WheelScrollDown {
                  focus-column-right
              }
              Mod+Shift+WheelScrollUp {
                  focus-column-left
              }
              Mod+Ctrl+Shift+WheelScrollDown {
                  move-column-right
              }
              Mod+Ctrl+Shift+WheelScrollUp {
                  move-column-left
              }
              Mod+1 {
                  focus-workspace 1
              }
              Mod+2 {
                  focus-workspace 2
              }
              Mod+3 {
                  focus-workspace 3
              }
              Mod+4 {
                  focus-workspace 4
              }
              Mod+5 {
                  focus-workspace 5
              }
              Mod+6 {
                  focus-workspace 6
              }
              Mod+7 {
                  focus-workspace 7
              }
              Mod+8 {
                  focus-workspace 8
              }
              Mod+9 {
                  focus-workspace 9
              }
              Mod+Ctrl+1 {
                  move-column-to-workspace 1
              }
              Mod+Ctrl+2 {
                  move-column-to-workspace 2
              }
              Mod+Ctrl+3 {
                  move-column-to-workspace 3
              }
              Mod+Ctrl+4 {
                  move-column-to-workspace 4
              }
              Mod+Ctrl+5 {
                  move-column-to-workspace 5
              }
              Mod+Ctrl+6 {
                  move-column-to-workspace 6
              }
              Mod+Ctrl+7 {
                  move-column-to-workspace 7
              }
              Mod+Ctrl+8 {
                  move-column-to-workspace 8
              }
              Mod+Ctrl+9 {
                  move-column-to-workspace 9
              }
              Mod+BracketLeft {
                  consume-or-expel-window-left
              }
              Mod+BracketRight {
                  consume-or-expel-window-right
              }
              Mod+Comma {
                  consume-window-into-column
              }
              Mod+Period {
                  expel-window-from-column
              }
              Mod+R {
                  switch-preset-column-width
              }
              Mod+Shift+R {
                  switch-preset-window-height
              }
              Mod+Ctrl+R {
                  reset-window-height
              }
              Mod+F {
                  maximize-column
              }
              Mod+Shift+F {
                  fullscreen-window
              }
              Mod+Ctrl+F {
                  expand-column-to-available-width
              }
              Mod+C {
                  center-column
              }
              Mod+Ctrl+C {
                  center-visible-columns
              }

              Mod+Minus {
                  set-column-width "-10%"
              }
              Mod+Equal {
                  set-column-width "+10%"
              }
              // Finer height adjustments when in column with other windows.
              Mod+Shift+Minus {
                  set-window-height "-10%"
              }
              Mod+Shift+Equal {
                  set-window-height "+10%"
              }
              // Move the focused window between the floating and the tiling layout.
              Mod+V {
                  toggle-window-floating
              }
              Mod+Shift+V {
                  switch-focus-between-floating-and-tiling
              }
              Mod+W {
                  toggle-column-tabbed-display
              }
              Mod+Shift+2 {
                  screenshot
              }
              Mod+Shift+3 {
                  screenshot-screen
              }
              Mod+Shift+4 {
                  screenshot-window
              }
              // Applications such as remote-desktop clients and software KVM switches may
              // request that niri stops processing the keyboard shortcuts defined here
              // so they may, for example, forward the key presses as-is to a remote machine.
              // It's a good idea to bind an escape hatch to toggle the inhibitor,
              // so a buggy application can't hold your session hostage.
              //
              // The allow-inhibiting=false property can be applied to other binds as well,
              // which ensures niri always processes them, even when an inhibitor is active.
              Mod+Escape allow-inhibiting=false {
                  toggle-keyboard-shortcuts-inhibit
              }
              // The quit action will show a confirmation dialog to avoid accidental exits.
              Mod+Shift+E {
                  quit
              }
              Ctrl+Alt+Delete {
                  quit
              }
              // Powers off the monitors. To turn them back on, do any input like
              // moving the mouse or pressing any other key.
              Mod+Shift+P {
                  power-off-monitors
              }
          }
          workspace "Main" {
              open-on-output "DP-1"
          }
          workspace "Code" {
              open-on-output "HDMI-A-2"
          }
          workspace "Messaging" {
              open-on-output "HDMI-A-2"
          }
          workspace "Music" {
              open-on-output "HDMI-A-2"
          }
          spawn-sh-at-startup "streamdeck -n"
          spawn-sh-at-startup "dms run"
          spawn-sh-at-startup "syncthing"
          spawn-at-startup "ghostty"
          spawn-at-startup "spotify"
          spawn-at-startup "obsidian"
          spawn-at-startup "discord"
          spawn-at-startup "signal-desktop"
          spawn-at-startup "slack"
          spawn-sh-at-startup "vicinae server"
          window-rule {
              match title="Ghostty"
              open-maximized true
          }
          window-rule {
              match at-startup=true title="Ghostty"
              open-on-workspace "Code"
          }
          window-rule {
              match at-startup=true title="Spotify"
              open-maximized true
              open-on-workspace "Music"
          }
          window-rule {
              match at-startup=true title="Obsidian"
              open-on-workspace "Main"
              default-column-width {
                  proportion 0.33333
              }
          }
          window-rule {
              match at-startup=true title="Zen Twilight"
              open-on-workspace "Main"
              default-column-width {
                  proportion 0.66667
              }
          }
          window-rule {
              match at-startup=true title="Slack"
              open-on-workspace "Messaging"
          }
          window-rule {
              match at-startup=true title="Discord"
              open-on-workspace "Messaging"
          }
          window-rule {
              match at-startup=true title="Signal"
              open-on-workspace "Messaging"
          }
          window-rule {
              match title="Friends List"
              default-column-width {
                  proportion 0.33333
              }
          }
          window-rule {
              match title="Soulframe"
              open-fullscreen true
          }
          window-rule {
              match is-focused=false
              opacity 0.85
          }
        '';
        programs.dank-material-shell = {
          enable = true;

          niri.enableSpawn = true;
          niri.includes = {
            enable = true; # Enable config includes hack. Enabled by default.
            override = false; # If disabled, DMS settings won't be prioritized over settings defined using niri-flake
            originalFileName = "hm"; # A new name (without extension) for the config file generated by niri-flake.
            filesToInclude = [
              # Files under `$XDG_CONFIG_HOME/niri/dms` to be included into the new config
              "alttab" # Please note that niri will throw an error if any of these files are missing.
              "binds"
              "colors"
              "layout"
              "outputs"
              "wpblur"
            ];
          };
        };
        services.vicinae = {
          enable = true;
        };
        home.file = {
          ".config/nvim/after/" = {
            source = ../../dots/nvim/after;
          };
          ".config/zellij/" = {
            source = ../../dots/zellij;
          };
          # ".config/ghostty/" = {
          #   source = ../../dots/ghostty;
          # };
          ".config/fzf/" = {
            source = ../../dots/fzf;
          };
          # ".config/niri/" = {
          #   source = ../../dots/niri;
          # };
          ".config/waybar/" = {
            source = ../../dots/waybar;
          };
          ".config/swww/" = {
            source = ../../dots/swww;
          };
        };
        home.packages = with pkgs; [
          (python313.withPackages (
            p: with p; [
              pandas
              requests
            ]
          ))
          sqlite
          _1password-cli
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
          #ice-bar
          yazi-unwrapped
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
          nautilus
          claude-code
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
          kdePackages.kcachegrind
          ollama-vulkan
        ];

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
          font = {
            name = "FiraCode Nerd Font Light";
            size = 10;
          };
          theme = {
            name = "Fluent-Dark";
            package = pkgs.fluent-gtk-theme;
          };
          iconTheme = {
            name = "Fluent";
            package = pkgs.fluent-icon-theme;
          };
        };
        # programs.walker = {
        #   enable = true;
        #   runAsService = true;
        # };
        #programs.waybar.enable = true;
        programs.zen-browser = {
          enable = true;
          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            # find more options here: https://mozilla.github.io/policy-templates/
          };
        };
        home.sessionVariables = {
          #GTK_THEME = "Fluent-Dark";
          #GTK_USE_PORTAL = "1";
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          #DISPLAY = ":0";
          #XDG_CURRENT_DESKTOP = "niri";
          #XDG_SESSION_TYPE = "wayland";
          #XDG_SESSION_DESKTOP = "niri";
          #HYPRSHOT_DIR = "/home/ryanm/Pictures/Screenshots";
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
          neovim = {
            enable = true;
            extraPackages = with pkgs; [
              lua-language-server
              phpactor
              intelephense
              typescript-language-server
              vscode-langservers-extracted
              tailwindcss-language-server
              nixd
              nixfmt
              marksman
              prettierd
              stylua
              ripgrep
              nodejs_24
              sql-formatter
              kdlfmt
              blade-formatter
              typos
              typos-lsp
            ];

            plugins =
              with pkgs.vimPlugins;
              with pkgs.tree-sitter-grammars;
              with pkgs.vscode-extensions;
              [
                mini-nvim
                leap-nvim
                ReplaceWithRegister
                # render-markdown-nvim
                bufferline-nvim
                blamer-nvim
                neorg
                conform-nvim
                comment-nvim
                delimitMate
                targets-vim
                bclose-vim
                gitsigns-nvim
                vim-matchup
                lsp-colors-nvim
                lsp_signature-nvim
                lualine-nvim
                noice-nvim
                nui-nvim
                blink-cmp-spell
                blink-cmp-dictionary
                blink-cmp-git
                blink-cmp
                nvim-lspconfig
                colorful-menu-nvim
                friendly-snippets
                nvim-notify
                nvim-web-devicons
                # plenary-nvim
                # telescope-fzf-native-nvim
                # telescope-nvim
                fzf-lua
                transparent-nvim
                (nvim-treesitter.withPlugins (p: [
                  p.javascript
                  p.php
                  p.html
                  p.css
                  p.markdown
                  p.dockerfile
                  p.bash
                  p.blade
                  p.csv
                  p.diff
                  p.git_config
                  p.git_rebase
                  p.gitcommit
                  p.gitignore
                  p.json
                  p.json5
                  p.lua
                  p.luadoc
                  p.tree-sitter-luap
                  p.markdown_inline
                  p.nix
                  p.nginx
                  p.passwd
                  p.phpdoc
                  p.php_only
                  p.python
                  p.tree-sitter-query
                  p.rust
                  p.robot
                  p.sql
                  p.ssh_config
                  p.tmux
                  p.typescript
                  p.vim
                  p.vimdoc
                  p.vue
                  p.xml
                  p.yaml
                  tree-sitter-norg
                  tree-sitter-norg-meta
                ]))
                image-nvim
                lspkind-nvim
                todo-comments-nvim
                trouble-nvim
                which-key-nvim
                neotest
                FixCursorHold-nvim
                nvim-nio
                neotest-phpunit
                nvim-navic
                nvim-spider
                oil-nvim
                vim-surround
                vim-repeat
                vim-abolish
                zellij-nav-nvim
                luasnip
                vim-matchup
                catppuccin-nvim
                everforest
                nvim-colorizer-lua
                xdebug.php-debug
                {
                  plugin = nvim-dap;
                  type = "lua";
                  config = ''
                    local dap = require('dap')
                    dap.adapters.php = {
                      type = 'executable',
                      command = 'node',
                      args = { '${xdebug.php-debug.out}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js' }
                    }

                    dap.configurations.php = {
                      {
                        type = 'php',
                        request = 'launch',
                        name = 'Listen for Xdebug',
                        port = 9003
                      }
                    }

                  '';
                }
                nvim-dap-ui
                {
                  plugin = pkgs.vimPlugins.sqlite-lua;
                  config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
                }
                {
                  plugin = nvim-neoclip-lua;
                  type = "lua";
                  config = ''
                    vim.diagnostic.config { virtual_lines = { current_line = true } }
                    require("neoclip").setup({
                        enable_persistent_history = true
                    })
                    vim.keymap.set("n", "<leader>nc", "<cmd>Telescope neoclip<cr>")
                  '';
                }
                (pkgs.fetchFromGitHub {
                  owner = "joe-re";
                  repo = "sql-language-server";
                  rev = "61f09a9";
                  sha256 = "A73coX1zS5PPXGwEgbLcBsg3lvJD1IXiEiyKX68620w=";
                })

                # (pkgs.fetchFromGitHub {
                #   owner = "V13Axel";
                #   repo = "neotest-pest";
                #   rev = "b665a48";
                #   sha256 = "uSPrvZPCjBhoAYTnAUQdMZ/CSosyRkj4itSQDZgthZ4=";
                # })
                (pkgs.fetchFromGitHub {
                  owner = "NTBBloodbath";
                  repo = "color-converter.nvim";
                  rev = "5888e92";
                  sha256 = "gQDSHeQnfMteZjr0Ji8wsTzo6alK/dgcVL3YSRVshyc=";
                })
              ];
            initLua = builtins.readFile ../../dots/nvim/init.lua;
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
        };
      };
    extraSpecialArgs = {
      inherit inputs;
      stdenv.hostPlatform.system = "x86_64-linux";
    };
  };
}
