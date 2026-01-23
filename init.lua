--+++++++++++++++++++++++++++++--
-- Andrew's nVIM Configuration --
--+++++++++++++++++++++++++++++--

local g = vim.g
local opt = vim.opt

-- OPTS AND CONFIGURATION
-- commands
vim.api.nvim_command("set noshowcmd")
vim.api.nvim_command("set nofoldenable")
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- globals
g.mapleader = " " -- makes the spacebar my leaderkey
g.maplocalleader = " " -- etc.
g.shiftround = true -- round indent
g.splitright = true -- put new windows right of current
g.background = "dark"
g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }
g.dashboard_default_executive = "telescope"

-- options
opt.mouse = "a" -- enable mouse for all modes

opt.cursorline = true -- highlight the current line
opt.smartindent = true -- automatically indent new lines
opt.wrap = true -- line wrapping
opt.number = true -- enable line numbers
opt.relativenumber = true -- enable relative line numbers

opt.smartcase = true -- don't ignore case with capitals
opt.spell = false -- spellcheck = flase

opt.termguicolors = true -- enable 24-bit RGB colors
opt.splitbelow = true -- put new windows below current
opt.splitkeep = "screen" -- scroll behaviour for split windows
opt.splitright = true -- put new windows right of current

opt.backup = false -- keep backup after overwriting a file
opt.swapfile = false -- f it we ball
opt.undofile = true -- save undo info to a file
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"

opt.expandtab = true -- tabs as spaces
opt.tabstop = 4 -- how long each tab looks
opt.softtabstop = 4 -- how many tab inserts or dels
opt.shiftwidth = 4 -- spaces when >> or <<

-- LAZY VIM CONFIGURATION
-- set up lazy for package management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", --latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- bring in plugins via lazy
require("lazy").setup({
	-- TREESITTER syntax highlighting; makes vim understand the code
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"bash",
					"python",
					"javascript",
					"typescript",
					"json",
					"html",
					"css",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},
	-- TELESCOPE fuzzy finding and searching; find files, buffers and text easily
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "❯ ",
				path_display = { "truncate" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			-- Optional: load extensions safely
			pcall(telescope.load_extension, "fzf")
		end,
	},
	-- CATPPUCCIN theming
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load before other UI plugins
		opts = {
			flavour = "frappe", -- latte, frappe, macchiato, mocha
			transparent_background = false,
			term_colors = true,
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
				},
				cmp = true,
				gitsigns = true,
				telescope = true,
				nvimtree = true,
				which_key = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	-- LUALINE status bar; like a dashboard for this editor
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			-- Lualine setup
			require("lualine").setup({
				options = { theme = "catppuccin" },
			})
		end,
	},
	-- WHICH-KEY 
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
		require("which-key").setup({
                triggers = {
                    { "<leader>", mode = { "n"}}, 
                },
            })
		end,
	},
	-- NVIM-TREE file-explorer; a sidebar tree of files and folders
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			-- Nvim-tree setup
			require("nvim-tree").setup({
				view = { width = 30, side = "left" },
				git = { enable = true },
			})
		end,
	},
	-- NEOSCROLL smooth scrolling; use ctrl+d and ctrl+u
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				easing_function = "quadratic",
				hide_cursor = true,
				stop_eof = true,
				respect_scrolloff = true,
				cursor_scrolls_alone = true,
				mappings = {
					"<C-u>",
					"<C-d>",
					"<C-b>",
					"<C-f>",
					"<C-y>",
					"<C-e>",
				},
				-- optional: set smooth scroll step for mouse
				scroll_step = 3,
			})
		end,
	},
})

-- KEYMAPS
local keymap = vim.keymap.set

-- telescope
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- nvim tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer", silent = true })
keymap("n", "<leader>o", "<cmd>NvimTreeFocus<CR>",  { desc = "Focus NvimTree" })
keymap("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" })


