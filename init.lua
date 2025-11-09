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


 -- THis is for \ for go and c running
vim.keymap.set("n", "\\", function()
-- Save current file
vim.cmd("write")

-- Detect file extension and build the run command
local filename = vim.fn.expand("%:t")          -- e.g., main.go or main.c
local extension = vim.fn.expand("%:e")         -- e.g., go or c
local run_cmd = ""

if extension == "go" then
  run_cmd = "go run " .. filename .. "\n"
  elseif extension == "c" then
    run_cmd = "fuck " .. filename .. "\n"
    else
      -- fallback: just run the file using default interpreter
      run_cmd = "./" .. filename .. "\n"
      end

      -- Open a horizontal split terminal
      vim.cmd("belowright split | terminal")

      -- Wait for terminal to start
      vim.defer_fn(function()
      local bufnr = vim.api.nvim_get_current_buf()
      local job_id = vim.b[bufnr] and vim.b[bufnr].terminal_job_id

      -- Always go into insert mode first
      vim.cmd("startinsert")

      if job_id and job_id ~= 0 then
        vim.fn.chansend(job_id, run_cmd)
        else
          local keys = vim.api.nvim_replace_termcodes(run_cmd, true, false, true)
          vim.api.nvim_feedkeys(keys, "t", true)
          end
          end, 300)
      end, { noremap = true, silent = true, desc = "Run current file in terminal" })




-- Use spaces instead of tab characters
vim.opt.expandtab = true

-- Number of spaces for each tab press
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Make indenting smarter
vim.opt.smartindent = true
vim.opt.autoindent = true


-- Unindent in normal mode
vim.keymap.set("n", "<leader><Tab>", "<<", { noremap = true, silent = true, desc = "Unindent line" })

-- Unindent in visual mode
vim.keymap.set("v", "<leader><Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent selection" })



-- Indent with Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
vim.keymap.set("v", "<leader><Tab>", "<gv", { noremap = true, silent = true, desc = "Unindent selection" })

require "plugins"
