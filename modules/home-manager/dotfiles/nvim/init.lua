vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.cmd("set dir=~/.swp/")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set smartindent")
vim.cmd("set backspace=2")
vim.cmd("set number")
vim.cmd("set nofoldenable")
vim.cmd("set relativenumber")
vim.cmd("set noerrorbells")
vim.cmd("set novisualbell")
vim.cmd("set hidden")
vim.cmd("set nobackup")
vim.cmd("set nowritebackup")
vim.cmd("set noshowmode")
vim.cmd("set splitbelow")
vim.cmd("set splitright")
vim.cmd("set mouse=a")
vim.cmd("set linebreak")
vim.cmd("set breakindent")
vim.cmd("set laststatus=3")
vim.cmd("set updatetime=300")
vim.cmd("set shortmess+=c")
vim.cmd("set signcolumn=yes")
vim.cmd("set smartcase")
vim.cmd("set termguicolors")
vim.cmd("set cmdheight=0")

vim.cmd("inoremap jj <Esc>")
vim.cmd("inoremap jk <Esc>")
vim.cmd("inoremap jJ <Esc>")
vim.cmd("nnoremap ; :")
vim.cmd("nnoremap : ;")
vim.cmd("nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')")
vim.cmd("nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')")
vim.cmd("nnoremap Y y$")
vim.cmd("nnoremap ` '")
vim.cmd("nnoremap ' `")
vim.cmd("let mapleader=' '")
vim.cmd("let maplocalleader=' '")
vim.cmd("set timeoutlen=500")

vim.cmd("nnoremap <silent> <C-h> <C-w>h")
vim.cmd("nnoremap <silent> <C-j> <C-w>j")
vim.cmd("nnoremap <silent> <C-k> <C-w>k")
vim.cmd("nnoremap <silent> <C-l> <C-w>l")
vim.cmd("nnoremap <silent> <leader>w :update<CR>")

vim.cmd("nnoremap <silent>]<space> :set paste<CR>m`o<Esc>``:set nopaste<CR>")
vim.cmd("nnoremap <silent>[<space> :set paste<CR>m`O<Esc>``:set nopaste<CR>")

vim.cmd("xnoremap <  <gv")
vim.cmd("xnoremap >  >gv")

vim.keymap.set(
	"n",
	"<leader>l",
	"<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-:l>",
	{ noremap = true }
)

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line("$")
		local not_commit = vim.b[args.buf].filetype ~= "commit"

		if valid_line and not_commit then
			vim.cmd([[normal! g`"]])
		end
	end,
})

vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>")
vim.keymap.set("n", "<leader>qc", "<cmd>close<cr>")
vim.keymap.set("n", "<leader>y", '"*y')

vim.cmd("autocmd filetype crontab setlocal nobackup nowritebackup")
vim.cmd("autocmd filetype markdown,norg,org setlocal spell")

vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "SpellBad", { fg = "#ff0000", undercurl = true })

vim.opt.fillchars = {
	horiz = "━",
	horizup = "┻",
	horizdown = "┳",
	vert = "┃",
	vertleft = "┫",
	vertright = "┣",
	verthoriz = "╋",
}
vim.cmd.colorscheme("catppuccin")
require("telescope").setup({
	defaults = {
		results_title = false,
		sorting_strategy = "ascending",
		layout_strategy = "center",
		layout_config = {
			preview_cutoff = 1, -- Preview should always show (unless previewer = false)
			width = function(_, max_columns, _)
				return math.min(max_columns, 80)
			end,
			height = function(_, _, max_lines)
				return math.min(max_lines, 15)
			end,
		},
		border = true,
		borderchars = {
			prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
			preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		},
		file_ignore_patterns = {
			"horizon/app.js",
			"*.min.js",
			"public/*",
			"node_modules/*",
		},
	},
})

require("telescope").load_extension("fzf")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>p", builtin.find_files, {})
vim.keymap.set("n", "<leader>fh", builtin.oldfiles)
vim.keymap.set("n", "<leader>e", builtin.buffers, {})
vim.keymap.set("n", "<leader>G", builtin.live_grep, {})
vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
vim.keymap.set("n", "<leader>ts", builtin.treesitter, {})

-- If you want the formatexpr, here is the place to set it
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier" },
		php = { "prettier", "php_cs_fixer" },
		blade = { "blade-formatter", "php_cs_fixer" },
		nix = { "nixfmt" },
	},

	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 2000, lsp_fallback = true }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

local nvim_lsp = require("lspconfig")
local navic = require("nvim-navic")
local servers = {
	"intelephense",
	"tsserver",
	"pyright",
	"jsonls",
	"lua_ls",
	"rust_analyzer",
	"tailwindcss",
	"marksman",
	"nixd",
}
nvim_lsp.typos_lsp.setup({})
nvim_lsp.markdown_oxide.setup({})
nvim_lsp.marksman.setup({})

local on_attach = function(client, bufnr, lsp)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
	-- vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

--
-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, lsp in ipairs(servers) do
	local standard = {
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = { diagnostics = { globals = { "vim" } } },
		},
	}
	local intelephense = {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "php", "blade" },
		init_options = {
			licenceKey = vim.fn.expand("$HOME/Developer/php-stuff/intelephense/licence.txt"),
		},
	}
	local setup = lsp == "intelephense" and intelephense or standard
	nvim_lsp[lsp].setup(setup)
end

nvim_lsp["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "blade" },
})

require("notify").setup({
	animate = false,
	stages = "static",
	max_width = 40,
	timeout = 2000,
	render = "wrapped-compact",
})
require("noice").setup({})

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(entry, vim_item)
				return vim_item
			end,
		}),
	},
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "nvim_lsp" },
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, { { name = "buffer" } }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer" } },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

require("luasnip.loaders.from_vscode").lazy_load()
require("lualine").setup({
	options = {
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
})
require("oil").setup({})
vim.g.blamer_enabled = true

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

require("nvim-treesitter.configs").setup({
	autotag = true,

	highlight = {
		enable = true,
	},
	ensure_installed = {},
})

require("neotest").setup({
	log_level = vim.log.levels.DEBUG,
	adapters = {
		require("neotest-pest")({
			sail_enabled = function()
				return false
			end,
		}),
	},
})

vim.keymap.set("n", "<leader>Tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end)
vim.keymap.set("n", "<leader>Tn", function()
	require("neotest").run.run()
end)
vim.keymap.set("n", "<leader>To", function()
	require("neotest").output_panel.toggle()
end)
require("colorizer").setup()
