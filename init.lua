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
-- Move selected lines up and down like VSCode Alt + ↑/↓
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")  -- Move down
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")  -- Move up

require "plugins"
