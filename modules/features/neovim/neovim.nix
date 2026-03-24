{ self, inputs, ... }:
{
  flake.nvimWrapper =
    {
      config,
      wlib,
      lib,
      pkgs,
      ...
    }:
    {
      config.extraPackages = with pkgs; [
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

      config.specs.start =
        let
          v = pkgs.vimPlugins;
        in
        [

          v.ReplaceWithRegister
          v.bufferline-nvim
          v.blamer-nvim
          v.conform-nvim
          v.comment-nvim
          v.delimitMate
          v.targets-vim
          v.bclose-vim
          v.gitsigns-nvim
          v.vim-matchup
          v.lsp-colors-nvim
          v.lualine-nvim
          v.noice-nvim
          v.nui-nvim
          v.blink-cmp-spell
          v.blink-cmp-dictionary
          v.blink-cmp-git
          v.blink-cmp
          v.nvim-lspconfig
          v.colorful-menu-nvim
          v.friendly-snippets
          v.nvim-notify
          v.nvim-web-devicons
          v.fzf-lua
          v.transparent-nvim
          v.nvim-treesitter-parsers.blade
          (v.nvim-treesitter.withPlugins (p: [
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
          ]))
          v.image-nvim
          v.lspkind-nvim
          v.todo-comments-nvim
          v.trouble-nvim
          v.which-key-nvim
          v.neotest
          v.FixCursorHold-nvim
          v.nvim-nio
          v.neotest-phpunit
          v.nvim-navic
          v.nvim-spider
          v.oil-nvim
          v.vim-surround
          v.vim-repeat
          v.vim-abolish
          v.zellij-nav-nvim
          v.luasnip
          v.catppuccin-nvim
          v.everforest
          v.nvim-colorizer-lua
          v.base16-nvim
        ];
      config.specs.initLua = {
        data = builtins.readFile ./init.lua;
      };
    };
  flake.nixosModules.neovim =
    { pkgs, lib, ... }:
    {
      programs.neovim = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.configuredNeovim;
      };
    };
  perSystem =
    {
      config,
      wlib,
      lib,
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      packages.configuredNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        imports = [ self.nvimWrapper ];
      };
    };
}
