require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- DAP mappings
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Run or continue the debugger" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })

-- DAP Go mappings
map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })
map("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

-- General mappings
map("i", "jk", "<ESC>", { desc = "To normal mode" })
map("i", "<C-s>", "<cmd> wa <CR>", { desc = "Save all files" })
map("n", "<C-s>", "<cmd> wa <CR>", { desc = "Save all files" })
-- map("n", "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<CR>", { desc = "Add harpoon mark" })
-- map("n", "<leader>r", function()
--   local index = require("harpoon.mark").get_index_of(vim.fn.bufname())
--   require("harpoon.mark").rm_file(index)
-- end, { desc = "Remove harpoon mark" })
-- map("n", "<S-k>", "<cmd>lua require('harpoon.ui').nav_next()<CR>", { desc = "Next harpoon mark" })
-- map("n", "<S-l>", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", { desc = "Prev harpoon mark" })
map("n", "<leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume Telescope" })
-- map("n", "<leader>ml", "<cmd>Telescope harpoon marks<CR>", { desc = "List harpoon marks" })
map("n", "<leader>fl", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Run make it rain from cellularautomaton" })

-- Copilot mappings
map("i", "<C-l>", function()
  vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
end, { replace_keycodes = true, nowait = true, silent = true, expr = true, noremap = true, desc = "Copilot Accept" })

-- LSP mappings
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "LSP references" })
map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "LSP definations" })

-- Gopher mappings
map("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
map("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })

-- Below keys have been converted to use map function instead
-- local M = {}

-- M.dap = {
--   plugin = true,
--   n = {
--     ["<leader>db"] = {
--       "<cmd> DapToggleBreakpoint <CR>",
--       "Add breakpoint at line",
--     },
--     ["<leader>dr"] = {
--       "<cmd> DapContinue <CR>",
--       "Run or continue the debugger",
--      },
--     ["<leader>dus"] = {
--       function()
--         local widgets = require "dap.ui.widgets"
--         local sidebar = widgets.sidebar(widgets.scopes)
--         sidebar.open()
--       end,
--       "Open debugging sidebar",
--     },
--   },
-- }
--
-- M.general = {
--   i = {
--     ["jk"] = { "<ESC>", "To normal mode" },
--     ["<C-s>"] = { "<cmd> wa <CR>", "Save all files" },
--   },
--
--   n = {
--     ["<C-s>"] = { "<cmd> wa <CR>", "Save all files" },
--     ["<leader>a"] = {
--       "<cmd>lua require('harpoon.mark').add_file()<CR>",
--       "Add harpoon mark",
--     },
--     ["<leader>r"] = {
--       function()
--         local index = require("harpoon.mark").get_index_of(vim.fn.bufname())
--         -- require("mini.bufremove").delete(0, true)
--         require("harpoon.mark").rm_file(index)
--       end,
--       "Remove harpoon mark",
--     },
--     ["<S-k>"] = {
--       "<cmd>lua require('harpoon.ui').nav_next()<CR>",
--       "Next harpoon mark",
--     },
--     ["<S-l>"] = {
--       "<cmd>lua require('harpoon.ui').nav_prev()<CR>",
--       "Prev harpoon mark",
--     },
--     ["<leader>fr"] = {
--       "<cmd>Telescope resume<CR>",
--       "Resume Telescope",
--     },
--     ["<leader>ml"] = {
--       "<cmd>Telescope harpoon marks<CR>",
--       "List harpoon marks",
--     },
--     ["<leader>fl"] = {
--       "<cmd>CellularAutomaton make_it_rain<CR>",
--       "Run make it rain from cellularautomaton",
--     },
--   },
-- }
--
-- M.copilot = {
--   i = {
--     ["<C-l>"] = {
--       function()
--         vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
--       end,
--       "Copilot Accept",
--       { replace_keycodes = true, nowait = true, silent = true, expr = true, noremap = true },
--     },
--   },
-- }
--
-- M.lspjonfig = {
--   plugin = true,
--   n = {
--     ["gr"] = { "<cmd>Telescope lsp_references<cr>", "LSP references" },
--     ["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "LSP definations" },
--   },
-- }
--
-- M.automation = {
--   plugin = true,
--   n = {},
-- }
--
-- M.dap_go = {
--   plugin = true,
--   n = {
--     ["<leader>dgt"] = {
--       function()
--         require("dap-go").debug_test()
--       end,
--       "Debug go test",
--     },
--     ["<leader>dgl"] = {
--       function()
--         require("dap-go").debug_last()
--       end,
--       "Debug last go test",
--     },
--   },
-- }
--
-- M.gopher = {
--   plugin = true,
--   n = {
--     ["<leader>gsj"] = {
--       "<cmd> GoTagAdd json <CR>",
--       "Add json struct tags",
--     },
--     ["<leader>gsy"] = {
--       "<cmd> GoTagAdd yaml <CR>",
--       "Add yaml struct tags",
--     },
--   },
-- }
--
-- return M
--
