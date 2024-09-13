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
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
    FZF_DEFAULT_OPTS = ''
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
        (pkgs.fetchFromGitHub {
          owner = "ricardoramirezr";
          repo = "blade-nav.nvim";
          rev = "a1a715f";
          sha256 = "11yywwi9qfgkp90jf3vhssz7bsdxw1jvjkrc5zw36h36bh4qsf61";
        })
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
        catppuccin-nvim
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
      };
      initExtra = ''
        bindkey -v
        bindkey '^ ' autosuggest-accept
        bindkey '^P' history-substring-search-up
        bindkey '^N' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '';
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    };
  };
}
