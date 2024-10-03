{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.stateVersion = "24.11";

  home.file = {
    ".config/nvim/after/" = {
      source = ./dotfiles/nvim/after;
    };
    ".config/zellij/" = {
      source = ./dotfiles/zellij;
    };
    ".config/aerospace/" = {
      source = ./dotfiles/aerospace;
    };
  };
  home.packages = with pkgs; [
    sqlite
    curl
    less
    ffmpeg_7-full
    nb
    poppler
    prettyping
    redis
    tailscale
    gh
    tree
    delta
    nix-prefetch-git
    cachix
    magic-wormhole
    ice-bar
    yazi-unwrapped
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    # LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";
    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_DEFAULT_OPTS = ''
        --height=20% \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'';
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
    HERD_PHP_82_INI_SCAN_DIR = "/Users/ryanmorton/Library/Application Support/Herd/config/php/82/";
    HERD_PHP_74_INI_SCAN_DIR = "/Users/ryanmorton/Library/Application Support/Herd/config/php/74/";
    HERD_PHP_81_INI_SCAN_DIR = "/Users/ryanmorton/Library/Application Support/Herd/config/php/81/";
    HERD_PHP_80_INI_SCAN_DIR = "/Users/ryanmorton/Library/Application Support/Herd/config/php/80/";
    HERD_PHP_83_INI_SCAN_DIR = "/Users/ryanmorton/Library/Application Support/Herd/config/php/83/";
    PATH = "/Users/ryanmorton/Library/Application Support/Herd/bin/:$PATH";

  };
  programs = {
    zellij.enable = true;
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
        intelephense
        typescript-language-server
        vscode-langservers-extracted
        tailwindcss-language-server
        nixd
        marksman
        typos-lsp
        stylua
        ripgrep
        nodePackages.intelephense
        nodejs_22
      ];

      plugins = with pkgs.vimPlugins; [
        ReplaceWithRegister
        render-markdown
        bufferline-nvim
        blamer-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        comment-nvim
        delimitMate
        targets-vim
        bclose-vim
        gitsigns-nvim
        lsp-colors-nvim
        lsp_signature-nvim
        lualine-nvim
        noice-nvim
        nui-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-notify
        nvim-web-devicons
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        transparent-nvim
        (nvim-treesitter.withPlugins (
          _:
          nvim-treesitter.allGrammars
          ++ [
            (pkgs.tree-sitter.buildGrammar {
              language = "blade";
              version = "8af0aab";
              src = pkgs.fetchFromGitHub {
                owner = "EmranMR";
                repo = "tree-sitter-blade";
                rev = "5eae5e1";
                sha256 = "ABbId48TDHwIRFtM3WpHoQR07BpXimdZbUCzRXyicYM=";
              };
            })
          ]
        ))
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
        luasnip
        matchit-zip
        catppuccin-nvim
        nvim-colorizer-lua
        {
          plugin = sqlite-lua;
          type = "lua";
          config = ''
            vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.dylib'
          '';
        }
        {
          plugin = nvim-neoclip-lua;
          type = "lua";
          config = ''
            require("neoclip").setup({
                enable_persistent_history = true
            })
            vim.keymap.set("n", "<leader>nc", "<cmd>Telescope neoclip<cr>")
          '';
        }
        (pkgs.fetchFromGitHub {
          owner = "V13Axel";
          repo = "neotest-pest";
          rev = "b665a48";
          sha256 = "uSPrvZPCjBhoAYTnAUQdMZ/CSosyRkj4itSQDZgthZ4=";
        })
      ];
      extraLuaConfig = builtins.readFile ./dotfiles/nvim/init.lua;
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
        art = "php artisan";
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
        php = "herd php";
        composer = "herd composer";
        za = "zellij attach $(zellij list-sessions --no-formatting --short | fzf)";
      };
      initExtra = ''
                setopt autopushd
                # Define an init function and append to zvm_after_init_commands
        function my_init() {
                bindkey '^ ' autosuggest-accept
          [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
        }
        zvm_after_init_commands+=(my_init)
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        import = [
          "~/.config/nix/modules/home-manager/dotfiles/catppuccin-mocha.toml"
        ];
        env = {
          TERM = "xterm-256color";
        };
        font = {
          size = 16;
          normal = {
            family = "NotoMono Nerd Font";
          };
        };
      };
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
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    };
  };
}
