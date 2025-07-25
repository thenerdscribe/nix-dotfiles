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
        home.stateVersion = "24.11";

        imports = [
          inputs.zen-browser.homeModules.twilight
        ];

        home.file = {
          ".config/nvim/after/" = {
            source = ../../dots/nvim/after;
          };
          ".config/zellij/" = {
            source = ../../dots/zellij;
          };
          ".config/ghostty/" = {
            source = ../../dots/ghostty;
          };
          ".config/fzf/" = {
            source = ../../dots/fzf;
          };
        };
        home.packages = with pkgs; [
          (python313.withPackages (
            p: with p; [
              pandas
            ]
          ))
          sqlite
          go
          curl
          less
          nh
          ffmpeg_7-full
          nb
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
          imagemagick
          pup
          font-awesome
          slack
          discord
          spotify
          _1password-gui
          sqlite
          playerctl
          obsidian
          signal-desktop
          zellij
          hyprsunset
          hyprshot
          hyprcursor
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
          catppuccin-cursors.mochaRed
          nautilus
          calibre
          audacious
          sushi
          cheese
          swaynotificationcenter
          lolcat
          hyprlandPlugins.hy3
          pavucontrol
          neofetch
          dconf
          streamdeck-ui
          libsecret
          pulseaudio
          wlvncc
          wezterm
          ghostty
          termusic
          wf-recorder
          openrgb-with-all-plugins
          wget
          whitesur-gtk-theme
          wlogout
          postman
          syncthing
          realvnc-vnc-viewer
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
          theme = {
            name = "WhiteSur-Dark";
            package = pkgs.whitesur-gtk-theme;
          };
          iconTheme = {
            name = "WhiteSur";
            package = pkgs.whitesur-icon-theme;
          };
        };

        home.file.".profile".text = ''
          export HYPRSHOT_DIR=/home/ryanm/Pictures/Screenshots/
        '';
        wayland.windowManager.hyprland = {
          extraConfig = ''
            plugin = ${pkgs.hyprlandPlugins.hy3}/lib/libhy3.so
            env = HYPRSHOT_DIR,/home/ryanm/Pictures/Screenshots/
          '';
          enable = true;
          plugins = [
            pkgs.hyprlandPlugins.hy3
          ];
          settings = {
            "$terminal" = "ghostty";
            "$fileManager" = "nautilus";
            "$menu" = "rofi -show drun";
            "exec-once" = [
              "waybar & swww-daemon & hyprshell run & hyprsunsent & swaync"
              "wl-paste --watch cliphist store"
              "streamdeck -n"
              "syncthing"
              "~/.config/swww/swww_randomize.sh ~/Pictures/wallpapers 300"
            ];
            monitor = [
              "DP-1,preferred,0x0,1"
              "HDMI-A-2,preferred,2560x-250,2,transform, 1"
            ];
            general = {
              gaps_in = 10;
              gaps_out = 10;
              border_size = 4;
              resize_on_border = true;
              allow_tearing = false;
              layout = "hy3";
              "col.active_border" = "rgba(ef59f9ee) rgba(59abf9ee) 45deg";
              "col.inactive_border" = "rgba(595959aa)";
            };
            decoration = {
              rounding = 20;
              rounding_power = 4;
              active_opacity = 1.0;
              inactive_opacity = 0.75;

              shadow = {
                enabled = false;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };

              blur = {
                enabled = true;
                size = 5;
                passes = 3;
                vibrancy = 0.4;
              };
            };
            animations = {
              enabled = "yes";
              first_launch_animation = true;

              # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = [
                "easeOutQuint,0.23,1,0.32,1"
                "easeInOutCubic,0.65,0.05,0.36,1"
                "linear,0,0,1,1"
                "almostLinear,0.5,0.5,0.75,1.0"
                "quick,0.15,0,0.1,1"
              ];

              animation = [
                "global, 1, 10, default"
                "border, 1, 5.39, easeInOutCubic"
                "windows, 1, 5, easeInOutCubic, slide"
                "windowsIn, 1, 5, easeInOutCubic, slide"
                "windowsOut, 1, 5, easeInOutCubic, slide"
                "fadeIn, 1, 1.73, almostLinear"
                "fadeOut, 1, 1.46, almostLinear"
                "fade, 1, 3.03, quick"
                "layers, 1, 3.81, easeOutQuint"
                "layersIn, 1, 4, easeOutQuint, fade"
                "layersOut, 1, 1.5, linear, fade"
                "fadeLayersIn, 1, 1.79, almostLinear"
                "fadeLayersOut, 1, 1.39, almostLinear"
                "workspaces, 1, 3, easeInOutCubic, slide"
                "workspacesIn, 1, 3, easeInOutCubic, slide"
                "workspacesOut, 1, 3, easeInOutCubic, slide"
              ];
            };
            workspace = [
              "1, monitor:DP-1"
              "2, monitor:DP-1"
              "3, monitor:HDMI-A-2"
              "4, monitor:HDMI-A-2"
              "5, monitor:HDMI-A-2"
            ];
            input = {
              kb_layout = "us";
              follow_mouse = 1;
              sensitivity = 0;
              natural_scroll = false;
              repeat_delay = 300;
              repeat_rate = 50;
            };
            "$mainMod" = "SUPER";
            "$secondaryMod" = "ALT";
            bind = [
              "$mainMod, q, killactive,"
              "$mainMod, M, exec, wlogout,"
              "$mainMod, E, exec, $fileManager"
              "$secondaryMod, f, togglefloating,"
              "$mainMod, space, exec, $menu run -show-icons"
              "$mainMod SHIFT, space, exec, $menu window -show-icons "
              "$mainMod CTRL, f, fullscreen, # dwindle"
              "SUPER CTRL ALT SHIFT, c, exec, rofi -modi clipboard:~/.config/rofi/cliphist-rofi -show clipboard -show-icons"
              "SUPER CTRL ALT SHIFT, space, exec, ~/Scripts/run-appimage"
              "SUPER SHIFT, 2, exec, hyprshot -m window"
              "SUPER SHIFT, 3, exec, hyprshot -m output -m active"
              "SUPER SHIFT, 4, exec, hyprshot -m region"
              "$secondaryMod, h, hy3:movefocus, l"
              "$secondaryMod, j, hy3:movefocus, d"
              "$secondaryMod, k, hy3:movefocus, u"
              "$secondaryMod, l, hy3:movefocus, r"

              "$mainMod CTRL, h, hy3:movewindow, l"
              "$mainMod CTRL, j, hy3:movewindow, d"
              "$mainMod CTRL, k, hy3:movewindow, u"
              "$mainMod CTRL, l, hy3:movewindow, r"
              "$mainMod CTRL, v, hy3:makegroup, v"
              "$mainMod CTRL, t, hy3:makegroup, h"

              "$mainMod ALT, h, resizeactive, -30 0"
              "$mainMod ALT, j, resizeactive, 0 30"
              "$mainMod ALT, k, resizeactive, 0 -30"
              "$mainMod ALT, l, resizeactive, 30 0"

              "$secondaryMod, 1, workspace, 1"
              "$secondaryMod, 2, workspace, 2"
              "$secondaryMod, 3, workspace, 3"
              "$secondaryMod, 4, workspace, 4"
              "$secondaryMod, 5, workspace, 5"
              "$mainMod CONTROL, 1, movetoworkspace, 1"
              "$mainMod CONTROL, 2, movetoworkspace, 2"
              "$mainMod CONTROL, 3, movetoworkspace, 3"
              "$mainMod CONTROL, 4, movetoworkspace, 4"
              "$mainMod CONTROL, 5, movetoworkspace, 5"
              ", XF86AudioPlay, exec, playerctl --player=spotify,termusic,audacious,firefox play-pause"
            ];
            windowrule = [
              "suppressevent maximize, class:.*"
              "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
            ];
            layerrule = [
              "blur, swaync-control-center"
              "blur, swaync-notification-window"
              "ignorezero, swaync-control-center"
              "ignorezero, swaync-notification-window"
              "ignorealpha 0.5, swaync-control-center"
              "ignorealpha 0.5, swaync-notification-window"
              "blur, rofi"
              "ignorezero, rofi"
              "ignorealpha 0.5, rofi"
            ];
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
        home.sessionVariables = {
          GTK_THEME = "WhiteSur-Dark";
          HYPRSHOT_DIR = "/home/ryanm/Pictures/Screenshots";
          GOPATH = "/home/ryanm/go";
          PHP_CS_FIXER_IGNORE_ENV = 1;
          EDITOR = "nvim";
          FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
          FZF_CTRL_T_OPTS = ''
            --walker-skip .git,node_modules,target \
            --preview 'bat -n --color=always {}' \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' '';
          FZF_CTRL_R_OPTS = ''
            --preview 'echo {}' --preview-window up:3:hidden:wrap
            --bind 'ctrl-/:toggle-preview'
            --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
            --color header:italic
            --header 'Press CTRL-Y to copy command into clipboard' '';
          FZF_ALT_C_OPTS = ''
            --walker-skip .git,node_modules,target
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
              nixfmt-rfc-style
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
              [
                mini-nvim
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
                obsidian-nvim
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
                plenary-nvim
                telescope-fzf-native-nvim
                telescope-nvim
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
                nvim-colorizer-lua
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
                  owner = "adibhanna";
                  repo = "laravel.nvim";
                  rev = "6ba7713";
                  sha256 = "OCu7yWu9H+n78Uv8lCZ0LrSWIH9AVB3SMlNoJD3/QWE=";
                })
              ];
            extraLuaConfig = builtins.readFile ../../dots/nvim/init.lua;
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
                [](#cba6f7)$username[](bg:#f38ba8 fg:#cba6f7)$directory[](bg:#fab387 fg:#f38ba8)$git_branch$git_status[](bg:#f9e2af fg:#fab387)$nix_shell[](bg:#74c7ec fg:#f9e2af)$time[ ](fg:#74c7ec)
                $character 
              '';
              directory = {
                style = "bg:#f38ba8 fg:#11111b";
                format = "[ $path ]($style)";
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
                style_user = "bg:#cba6f7 fg:#11111b";
                style_root = "bg:#cba6f7 fg:#11111b";
                format = "[ 󰿘 ]($style)";
              };
              git_branch = {
                symbol = "";
                style = "bg:#fab387 fg:#11111b";
                format = "[ $symbol $branch ]($style)";
              };
              git_status = {
                style = "bg:#fab387 fg:#11111b";
                format = "[$all_status$ahead_behind ]($style)";
              };
              character = {
                format = "[ $symbol ](bg: #45475a)";
                vimcmd_symbol = "[ ](fg:#f9e2af)";
                success_symbol = "[ ](fg:#a6e3a1)";
                error_symbol = "[ ](fg:#f38ba8)";
                vimcmd_replace_symbol = "[R](fg:#f9e2af)";
                vimcmd_replace_one_symbol = "[RO](fg:#f9e2af)";
                vimcmd_visual_symbol = "[V](fg:#f9e2af)";
              };
              nix_shell = {
                symbol = " ";
                format = "[ via $symbol$state( \($name\)) ]($style)";
                style = "bg:#f9e2af fg:#11111b";
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
      system = "x86_64-linux";
    };
  };
}
