{ self, inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, inputs, ... }:
    {
      programs.neovim = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.configuredNeovim;

      };
    };
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.configuredNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        extraPackages = with pkgs; [
          lua-language-server
          phpactor
          intelephense
          typescript-language-server
          vscode-langservers-extracted
          tailwindcss-language-server
          nixd
          rust-analyzer
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
            nvim-treesitter-parsers.blade
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
            base16-nvim
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
    };
}
