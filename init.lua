require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

--require('tabnine').setup({
-- disable_auto_comment=true,
-- accept_keymap="<Tab>",
-- dismiss_keymap = "<C-e>",
-- debounce_ms = 800,
-- suggestion_color = {gui = "#808080", cterm = 244},
-- exclude_filetypes = {"TelescopePrompt", "NvimTree"},
-- log_file_path = nil, -- absolute path to Tabnine log file
--})

-- Closes nvim if nvim-tree is the last window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- Setups session manager
local Path = require('plenary.path')
local config = require('session_manager.config')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
  dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.uv.cwd()` if the passed `dir` is `nil`.
  autoload_mode = config.AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
  autosave_last_session = false, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})

-- Configures nvim-tree to open on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		--vim.cmd("autocmd TermOpen * setlocal nonumber norelativenumber")
		--vim.cmd("15split term://bash")
		vim.cmd("NvimTreeToggle")
		vim.cmd("wincmd p")
	end,
})



vim.g.python_recommended_style = 0

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false


local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        if opts.desc then
            opts.desc = "keymaps.lua: " .. opts.desc
        end
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- here some of my mappings:
map("n", "gl", "`.", { desc = "Jump to the last change in the file"})
map("v", "<C-c>", '"*y :let @+=@*<CR>', { desc = "Copies into primary selection"})
map("i", "<C-v>", '<ESC>"*pli', { desc = "Pastes from primary selection"})
map("i", "<C-d>", "<ESC>yypi", { desc = "Duplicates line"})

map("n", "sq", ":SessionManager save_current_session<ENTER>:xa<ENTER>", { desc = "Saves current session and quits"})

map("t", "<ESC>", "<C-\\><C-N>", { desc = "Enter terminal normal mode" })

map("n", "<C-d>", ":q<ENTER>", { desc = "Quits vim"})
map("n", "<C-q>", ":q!<ENTER>", { desc = "Quits vim regardless of unsaved changed"})
map("v", "<C-d>", "<ESC>:q<ENTER>", { desc = "Quits vim"})
map("v", "<C-q>", "<ESC>:q!<ENTER>", { desc = "Quits vim regardless of unsaved changes"})

-- naviagte from terminal to editor 
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move left from terminal"})
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move down from terminal"})
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move up from terminal"})
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move right from terminal"})

-- navigate from insert editor to terminal
map("i", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move left from terminal"})
map("i", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move down from terminal"})
map("i", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move up from terminal"})
map("i", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move right from terminal"})

-- navigate from normal editor to terminal
map("n", "<C-h>", "<C-w>h", { desc = "Move left from terminal"})
map("n", "<C-j>", "<C-w>j", { desc = "Move down from terminal"})
map("n", "<C-k>", "<C-w>k", { desc = "Move up from terminal"})
map("n", "<C-l>", "<C-w>l", { desc = "Move right from terminal"})
