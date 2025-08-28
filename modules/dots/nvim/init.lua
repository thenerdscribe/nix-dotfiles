vim.opt.spelllang = "en_us"
-- vim.opt.spell = true
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
vim.opt.termsync = true

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
vim.keymap.set("n", "<leader>fh", function()
	builtin.oldfiles({ cwd_only = true })
end, {})
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
		php = { "prettier", "php-cs-fixer" },
		blade = { "blade-formatter", "php-cs-fixer" },
		nix = { "nixfmt" },
		sql = { "sql_formatter" },
		kdl = { "kdlfmt" },
	},
	formatters = {
		["php-cs-fixer"] = {
			command = "php-cs-fixer",
			args = {
				"fix",
				"$FILENAME",
			},
			stdin = false,
		},
	},
	notify_on_error = true,
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 10000, lsp_fallback = true }
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
	"ts_ls",
	"pyright",
	"jsonls",
	"lua_ls",
	"rust_analyzer",
	"tailwindcss",
	"marksman",
	"nixd",
	"typos_lsp",
	"laravel_ls",
}

nvim_lsp.markdown_oxide.setup({})
nvim_lsp.marksman.setup({})

local on_attach = function(client, bufnr, lsp)
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
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

require("blink.cmp").setup({
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		--
		-- ["<Tab>"] = { "snippet_forward", "fallback" },
		-- ["<S-Tab>"] = { "snippet_backward", "fallback" },
		--
		-- ["<Up>"] = { "select_prev", "fallback" },
		-- ["<Down>"] = { "select_next", "fallback" },
		-- ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		-- ["<C-n>"] = { "select_next", "fallback_to_mappings" },
		--
		-- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
		-- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
		--
		-- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},
	completion = {
		list = { selection = { preselect = false } },
		menu = {
			draw = {
				-- We don't need label_description now because label and label_description are already
				-- combined together in label by colorful-menu.nvim.
				columns = { { "kind_icon" }, { "label", gap = 1 } },
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
				},
			},
		},
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = { diagnostics = { globals = { "vim" } } },
		},
	})
end

require("color-converter").setup({})

nvim_lsp["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "blade" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
})

nvim_lsp.phpactor.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "php", "blade" },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

nvim_lsp.intelephense.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "php", "blade" },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "php", "blade" },
-- 	callback = function()
-- 		vim.lsp.start({
-- 			name = "laravel-ls",
-- 			cmd = { "sh", "/home/ryanm/go/pkg/mod/github.com/laravel-ls/laravel-ls@v0.0.8/start.sh" },
-- 			root_dir = vim.fn.getcwd(),
-- 		})
-- 	end,
-- })

require("notify").setup({
	animate = false,
	stages = "static",
	max_width = 40,
	timeout = 2000,
	-- render = "wrapped-compact",
})
require("noice").setup({})

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

require("lspkind").setup()

require("luasnip.loaders.from_vscode").lazy_load()
require("lualine").setup({
	options = {
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {},
		lualine_x = { "filetype" },
		lualine_y = {},
		lualine_z = { "location" },
	},
	winbar = {
		lualine_a = { "filename" },
		lualine_c = {
			{
				"navic",
				color_correction = nil,
				navic_opts = nil,
			},
		},
	},
})
require("oil").setup({})
vim.g.blamer_enabled = true

require("nvim-treesitter.configs").setup({
	autotag = true,
	matchup = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	highlight = {
		enable = true,
	},
	config = function()
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
})

require("neotest").setup({
	log_level = vim.log.levels.DEBUG,
	--	adapters = {
	-- require("neotest-pest")({
	-- 	sail_enabled = function()
	-- 		return false
	-- 	end,
	-- 	}),
	-- },
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

-- require("colorizer").setup()
require("trouble").setup()

vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_transmute_enabled = true

vim.keymap.set("n", "<leader>XX", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

require("zellij-nav").setup()
local map = vim.keymap.set
map("n", "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>", { desc = "navigate left or tab" })
map("n", "<c-j>", "<cmd>ZellijNavigateDown<cr>", { desc = "navigate down" })
map("n", "<c-k>", "<cmd>ZellijNavigateUp<cr>", { desc = "navigate up" })
map("n", "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { desc = "navigate right or tab", noremap = true })

vim.cmd("nnoremap <silent> <leader>w :update<CR>")

require("image").setup({
	processor = "magick_cli",
})
require("mini.align").setup()
require("transparent").setup({})

vim.api.nvim_create_user_command("Sqlify", function()
	vim.cmd('%norm yss"')
	vim.cmd("%norm A,")
	vim.cmd("norm G$xA)")
	vim.cmd("norm gg")
	vim.cmd("norm I(")
	vim.cmd("norm lxh")
end, {
	nargs = 0,
	desc = "Make a list SQLy",
	bang = false,
})

require("obsidian").setup({
	ui = { enable = true },
	workspaces = {
		{ name = "main", path = "~/Documents/Main" },
	},
	completion = {
		nvim_cmp = false,
		blink = true,
	},
})
require("leap").set_default_mappings()
