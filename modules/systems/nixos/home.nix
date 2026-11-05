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
          inputs.niri-flake.homeModules.niri
          inputs.dms.homeModules.dank-material-shell
          inputs.dcalendar.homeModules.dank-calendar
          inputs.dms.homeModules.niri
          inputs.zen-browser.homeModules.twilight
          inputs.mangowm.hmModules.mango
          inputs.dfiles.homeModules.dux-files
          ./niri.nix
          ./packages.nix
          ../../applications/neovim
        ];
        programs.niri.package = pkgs.niri;
        programs.dux-files = {
          enable = true;
          # Keep a resident instance so windows open fast and the portal answers at once
          systemd = {
            enable = true;
            target = "graphical-session.target";
            restartIfChanged = true;
          };

          # Serve other apps' open and save dialogs
          portal = {
            enable = true; # register the dfiles backend with xdg-desktop-portal
            preferred = true; # prefer it for org.freedesktop.impl.portal.FileChooser
            desktop = "mango"; # which xdg.portal.config entry gets the preference, "common" by default
          };

        };

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

        wayland.windowManager.mango = {
          enable = true;
          settings = {
            env = [
              "WLR_RENDERER,vulkan"
              "QT_QPA_PLATFORM,wayland"
              "ELECTRON_OZONE_PLATFORM_HINT,auto"
              "QT_QPA_PLATFORMTHEME,gtk3"
              "WLR_DRM_NO_ATOMIC,1"
            ];
            blur = "1";
            hdr_depth = "2";
            allow_tearing = "1";
            blur_params_radius = "7";
            blur_params_num_passes = "3";
            blur_optimized = "0";
            blur_layer = "1";
            unfocused_opacity = "0.75";
            border_radius = "16";
            exec_once = [
              "vicinae server"
              "dcal run -d --hidden"
              "syncthing"
              "/home/ryanm/Applications/pcpaneld/target/debug/pcpaneld daemon"
              "multimon-target"
              "streamdeck -n"
            ];
            focus_color = "0x82ffd6ff";
            cursor_theme = "Sweet-dark";
            cursor_size = "18";
            cursor_hide_timeout = "3";
            cursor_hide_on_keypress = "1";
            drag_tile_to_tile = "1";
            scroller_proportion_preset = [
              "0.25,0.33,0.5,0.66,0.75,1"
            ];
            monitor_rule = [
              "name:^DP-1$,vrr:1,hdr:1,x:0,y:0,width:2560,height:1440,refresh:239.99"
              "name:^DP-2$,vrr:1,x:2560,y:-505,rr:1,width:2560,height:1440,refresh:144"
              "name:^HDMI-A-1$,vrr:1,width:3840,height:2160,refresh:120.00"
            ];
            scroller_default_proportion = "0.5";
            scroller_default_proportion_single = "1.0";
            scroller_ignore_proportion_single = "0";
            edge_scroller_pointer_focus = "0";
            sync_obj_enable = true;
            disable_middle_paste = true;
            window_rule = [
              "tags:2,monitor:^DP-2$,app_id:discord"
              "tags:2,monitor:^DP-2$,app_id:slack"
              "tags:2,monitor:^DP-2$,app_id:tether-gtk"
              "tags:2,monitor:^DP-2$,app_id:signal"
              "tags:3,monitor:^DP-1,app_id:steam"
              "app_id:ghostty,title:RMPC,is_floating:1,is_overlay:1,width:0.75,height:0.75"
              "app_id:ghostty,title:TTUI,is_floating:1,is_overlay:1,width:0.75,height:0.75"
            ];
            tag_rule = [
              "id:*,monitor_name:^DP-1$,layout_name:scroller"
              "id:*,monitor_name:^DP-2$,layout_name:vertical_scroller"
              "id:*,monitor_name:^DP-2$,scroller_default_proportion:0.3333"
            ];
            binds = [
              "SUPER,q,killclient"
              "SUPER+CTRL,h,exchange_client,left"
              "SUPER+CTRL,j,exchange_client,down"
              "SUPER+CTRL,k,exchange_client,up"
              "SUPER+CTRL,l,exchange_client,right"
              "SUPER,r,switch_proportion_preset"
              "SUPER+SHIFT,f,togglefullscreen"
              "SUPER+SHIFT,p,spawn,~/Scripts/sleep_monitors.sh"
              "SUPER,y,switch_layout"
              "SUPER,t,spawn,ghostty"
              "SUPER,space,spawn,vicinae toggle"
              "SUPER,m,spawn,dms ipc call processlist toggle"
              "SUPER+SHIFT,space,spawn,dms ipc call spotlight toggle"

              # Screenshots
              "SUPER+SHIFT,code:11,spawn,capture-script fullscreen"
              "SUPER+SHIFT,code:12,spawn,capture-script region"
              "SUPER+SHIFT,code:13,spawn,capture-script window"
              "SUPER+SHIFT,code:14,spawn,capture-script annotate"

              "ALT,h,focusdir,left"
              "ALT,j,focusdir,down"
              "ALT,k,focusdir,up"
              "ALT,l,focusdir,right"

              "ALT,u,viewtoleft"
              "ALT,i,viewtoright"

              "SUPER+SHIFT,l,focusmon,right"
              "SUPER+SHIFT,h,focusmon,left"
              "SUPER+SHIFT+CTRL,l,tagmon,right"
              "SUPER+SHIFT+CTRL,h,tagmon,left"

              "SUPER,1,set_proportion,0.25"
              "SUPER,2,set_proportion,0.33"
              "SUPER,3,set_proportion,0.5"
              "SUPER,4,set_proportion,0.66"
              "SUPER,5,set_proportion,0.75"
              "SUPER,f,togglemaximizescreen"
              "SUPER+SHIFT,j,scroller_stack,left"
              "SUPER+SHIFT,k,scroller_stack,right"
              "SUPER,e,spawn,ghostty --title='Yazi' -e 'yazi'"
              "SUPER+SHIFT,e,spawn,dfiles"
              "SUPER+SHIFT,m,spawn,ghostty --title='RMPC' -e 'rmpc'"
              "SUPER+SHIFT,t,spawn,ghostty --title='TTUI' -e 'taskwarrior-tui'"
              "SUPER+SHIFT+CTRL+ALT,c,spawn,vicinae 'vicinae://launch/clipboard/history'"
              "SUPER,c,centerwin"
              "SUPER+CTRL,t,setkeymode,tags"
              "SUPER+CTRL,r,setkeymode,resize"
              "SUPER+CTRL,1,view,1"
              "SUPER+CTRL,2,view,2"
              "SUPER+CTRL,3,view,3"
              "SUPER,tab,focusstack,next"
              "SUPER+SHIFT,tab,focusstack,previous"
              "SUPER,o,toggleoverview"
              "NONE,XF86AudioLowerVolume,spawn,playerctl volume 0.05-"
              "NONE,XF86AudioRaiseVolume,spawn,playerctl volume 0.05+"
              "NONE,XF86AudioPrev,spawn,playerctl previous"
              "NONE,XF86AudioNext,spawn,playerctl next"
              "NONE,XF86AudioPlay,spawn,playerctl play-pause"
            ];
            key_mode.resize.bind = [
              "NONE,h,resizewin,+10,0"
              "NONE,l,resizewin,+10,0"
              "NONE,j,resizewin,0,+10"
              "NONE,k,resizewin,0,+10"
              "NONE,ESCAPE,setkeymode,default"
              "SUPER+CTRL,r,setkeymode,default"
            ];
            key_mode.tags.bind = [
              "SUPER,1,toggletag,1"
              "SUPER,2,toggletag,2"
              "SUPER,3,toggletag,3"
              "SUPER+SHIFT,1,tag,1"
              "SUPER+SHIFT,2,tag,2"
              "SUPER+SHIFT,3,tag,3"
              "NONE,1,view,1"
              "NONE,2,view,2"
              "NONE,3,view,3"
              "NONE,ESCAPE,setkeymode,default"
              "SUPER+CTRL,t,setkeymode,default"
            ];
            source = [
              "./dms/layout.conf"
            ];
          };
        };

        programs.dank-calendar.enable = true;

        programs.dank-material-shell = {
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

        home.file = {
          ".config/nvim/after/" = {
            source = ../../dots/nvim/after;
          };
          ".config/zellij/" = {
            source = ../../dots/zellij;
          };
          ".config/fzf/" = {
            source = ../../dots/fzf;
          };
          ".config/waybar/" = {
            source = ../../dots/waybar;
          };
          ".config/swww/" = {
            source = ../../dots/swww;
          };
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

        programs.zen-browser = {
          enable = true;
          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            # find more options here: https://mozilla.github.io/policy-templates/
          };
          nativeMessagingHosts = [ pkgs.firefoxpwa ];
        };
        services.kdeconnect.enable = true;

        home.sessionVariables = {
          GTK_THEME = "Fluent-Dark";
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "niri";
          QT_QPA_PLATFORM = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_QPA_PLATFORMTHEME = "gtk3";
          QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
          GOPATH = "/home/ryanm/go";
          PHP_CS_FIXER_IGNORE_ENV = 1;
          EDITOR = "nvim";
          FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
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
          };
          neovim = {
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
              nfu = "nix flake update";
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
              nrs = "sudo nixos-rebuild switch --flake '.#nixos'";
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
                function ns () {
                    nix-shell -p $1 --command zsh
                }
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
              eval "$(devenv hook zsh)"
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
                  Desktop = "󰇅";
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
