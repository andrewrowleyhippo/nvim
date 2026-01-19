
-- basic configs
vim.g.mapleader = " "           -- makes the spacebar my leaderkey
vim.o.cursorline = true         -- highlight the current line
vim.o.termguicolors = true      -- enable 24-bit RGB colors


-- tabbing
vim.cmd("set expandtab")        -- tabs as spaces
vim.cmd("set tabstop=4")        -- how long each tab looks
vim.cmd("set softtabstop=4")    -- how many tab inserts or dels
vim.cmd("set shiftwidth=4")     -- spaces when >> or <<
vim.o.smartindent = true        -- automatically indent new lines
vim.o.wrap = true               -- line wrapping


-- line nums
vim.o.number = true             -- enable line numbers
vim.o.relativenumber = true     -- enable relative line numbers


-- syntax highlighting and filetype plugins
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')


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
------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua","vim","vimdoc","bash","python",
        "javascript","typescript","json","html","css",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },})
    end,
  },
------------------------------
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      cmd = "Telescope",
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
------------------------------
  {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000, -- load before other UI plugins
      opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
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
------------------------------
})


-- telescope config
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })





