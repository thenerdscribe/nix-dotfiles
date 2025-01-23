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
    ".config/ghostty/" = {
      source = ./dotfiles/ghostty;
    };
    ".config/fzf/" = {
      source = ./dotfiles/fzf;
    };
  };
  home.packages = with pkgs; [
    sqlite
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
    ice-bar
    yazi-unwrapped
    imagemagick
  ];
  home.sessionVariables = {
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
        phpactor
        intelephense
        typescript-language-server
        vscode-langservers-extracted
        tailwindcss-language-server
        nixd
        marksman
        prettierd
        stylua
        ripgrep
        nodejs_22
        sql-formatter
        blade-formatter
        php84Packages.php-cs-fixer
      ];

      plugins =
        with pkgs.vimPlugins;
        with pkgs.tree-sitter-grammars;
        [
          ReplaceWithRegister
          render-markdown-nvim
          bufferline-nvim
          blamer-nvim
          cmp-buffer
          cmp-cmdline
          cmp-nvim-lsp
          neorg
          cmp-path
          cmp_luasnip
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
                version = "v0.11.0";
                src = pkgs.fetchFromGitHub {
                  owner = "EmranMR";
                  repo = "tree-sitter-blade";
                  rev = "47baa7ba1f9d5f436c7a72b052d2dac2166abf92";
                  sha256 = "sha256-N3QUylMqhX5aZGyIx1zfMe4xZRAwwE7e4MyhOiawCXw=";
                };
              })
              tree-sitter-norg
              tree-sitter-norg-meta
            ]
          ))
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
          luasnip
          vim-matchup
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
            owner = "joe-re";
            repo = "sql-language-server";
            rev = "61f09a9";
            sha256 = "A73coX1zS5PPXGwEgbLcBsg3lvJD1IXiEiyKX68620w=";
          })
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
        composer = "valet composer";
        php = "valet php";
        art = "php artisan";
        za = "zellij attach $(zellij list-sessions --no-formatting --short | fzf)";
        zlss = "zellij list-sessions --no-formatting --short";
        zls = "zellij list-sessions";
      };
      initExtra = ''
        setopt autopushd
        function my_init() {
          bindkey '^ ' autosuggest-accept
          [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
          export KEYTIMEOUT=2
          bindkey -r '^G'
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
}
