-- ~/.config/nvim/init.lua
-- Neovim configuration optimized for SSH development on Android/tablet
-- Updated for Neovim 0.11+ with vim.lsp.config

-- Leader key - using space is generally safe over SSH
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"

-- Per-folder Session Management
local Session = {}

-- Get session file path based on current directory
local function get_session_file()
  local cwd = vim.fn.getcwd()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  
  -- Create sessions directory if it doesn't exist
  vim.fn.mkdir(session_dir, "p")
  
  -- Convert directory path to a safe filename
  -- Replace / and \ with %% to avoid path issues
  local session_name = cwd:gsub("/", "%%"):gsub("\\", "%%")
  
  return session_dir .. "/" .. session_name .. ".vim"
end

-- Save session for current directory
function Session.save()
  local session_file = get_session_file()
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
  print("Session saved: " .. vim.fn.getcwd())
end

-- Load session for current directory
function Session.load()
  local session_file = get_session_file()
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(session_file))
    print("Session loaded: " .. vim.fn.getcwd())
  end
end

-- Auto-save on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    Session.save()
  end,
})

-- Auto-load on enter (only if no files were specified)
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    -- Only auto-load if nvim was opened without file arguments
    if vim.fn.argc() == 0 then
      Session.load()
    end
  end,
})

-- Optional: Add manual keymaps for session management
vim.keymap.set("n", "<leader>ss", Session.save, { desc = "Save session" })
vim.keymap.set("n", "<leader>sl", Session.load, { desc = "Load session" })


-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- Color scheme
  {
    "maxmx03/solarized.nvim",
    inverse = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme solarized]])
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "elixir", "heex", "eex", "lua", "vim", "javascript", "html", "css" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP Configuration - using modern vim.lsp.config approach
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure Elixir LS using vim.lsp.config (Neovim 0.11+)
      vim.lsp.config('elixirls', {
        cmd = { os.getenv("HOME") .. "/.elixir-ls/release/language_server.sh" },
        filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
        root_markers = { 'mix.exs', '.git' },
        capabilities = capabilities,
        settings = {
          elixirLS = {
            dialyzerEnabled = false, -- Disable for performance on mobile
            fetchDeps = false,
          }
        }
      })

      -- Enable Elixir LS on appropriate buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'elixir', 'eelixir', 'heex', 'surface' },
        callback = function()
          vim.lsp.enable('elixirls')
        end,
      })

      -- LSP Keymaps (using leader for safety)
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      
      -- Format on save for Elixir files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ex", "*.exs", "*.heex", "*.eex" },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = true,
          keymap = {
            accept = "<C-y>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
      })
    end,
  },

  -- Copilot completion source for nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Copilot Chat (AI agents)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        window = {
          layout = "vertical",
          width = 0.4,
        },
      })

      -- Copilot Chat keymaps
      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
      vim.keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain code" })
      vim.keymap.set("n", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review code" })
      vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix code" })
      vim.keymap.set("n", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize code" })
      vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDocs<cr>", { desc = "Generate docs" })
      vim.keymap.set("n", "<leader>ct", "<cmd>CopilotChatTests<cr>", { desc = "Generate tests" })
      vim.keymap.set("n", "<leader>cp", "<cmd>Copilot toggle<cr>", { desc = "Toggle Copilot" })
      vim.keymap.set("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Chat with selection" })

    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
        }),
      })
    end,
  },

  -- File explorer (simpler than telescope for mobile)
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          -- ["`"] = false, -- Disable the backtick keymap
          ["<leader>d"] = {
            callback = function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              
              if entry and entry.type == "directory" then
                -- If cursor is on a directory, cd into it
                local target_dir = dir .. entry.name .. "/"
                vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
                oil.open(target_dir)  -- Navigate Oil into the directory
                vim.notify("Changed directory to: " .. target_dir)
              elseif dir then
                -- If cursor is not on a directory, cd to current Oil directory
                vim.cmd("cd " .. vim.fn.fnameescape(dir))
                vim.notify("Changed directory to: " .. dir)
              end
            end,
            desc = "Change working directory to selected/current directory",
          },
          ["<C-r>"] = "actions.refresh",
        },
      })
      vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open file explorer" })
    end,
  },

  -- Fuzzy finder (essential but using simple keymaps)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "vertical", -- Better for narrow screens
          layout_config = {
            vertical = {
              width = 0.9,
              height = 0.9,
              preview_height = 0.6,
            }
          },
        },
      })

      -- Telescope keymaps
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "<leader>hn", gs.next_hunk, { desc = "Next hunk" })
          map("n", "<leader>hp", gs.prev_hunk, { desc = "Previous hunk" })
          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
        end
      })
    end,
  },

  -- Neogit: Full-featured git interface
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
          diffview = true,
        },
      })
      
      -- Neogit keymaps
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<cr>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gl", "<cmd>Neogit pull<cr>", { desc = "Git pull" })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "solarized",
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
      -- Default: gcc (line), gbc (block)
    end,
  },

  -- Elixir-specific plugins
  {
    "elixir-tools/elixir-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ToggleTerm: terminal inside Neovim (minimal setup + mapping)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = false,
        direction = "float",
        close_on_exit = false,
        persist_size = true,
      })
      -- Toggle terminal mapping (leader + tt)
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
    end,
  },

})

-- General keymaps (safe for SSH)
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and quit" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Window navigation
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })

-- Clear highlighting
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear highlights" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Utility: run shell commands and populate quickfix so clicking works
-- └─ test/support/app/accounts/user.ex:57:54: Aurora.Uix.Test.Accounts.User.changeset/2

local function parse_and_build_qf(lines)
  -- lines: array of strings from command output
  local qf_items = {}

  for _, raw in ipairs(lines) do
    if raw == nil or raw == "" then
      goto continue
    end

    -- Try pattern: path:line:col: message
    local path, lnum, col, msg = raw:match("^[ \t└─]*([a-z/%.]+):(%d+):(%d+): (.*)")
    if path and lnum then
      table.insert(qf_items, { filename = path, lnum = tonumber(lnum), col = tonumber(col), text = msg })
      goto continue
    end

    -- Try pattern: path:line: message
    path, lnum, msg = raw:match("^[ \t└─]*([a-z/%.]+):(%d+): (.*)")
    if path and lnum then
      table.insert(qf_items, { filename = path, lnum = tonumber(lnum), text = msg })
      goto continue
    end

    -- Try pattern with leading "./" or absolute paths containing spaces (rare)
    path, lnum, col, msg = raw:match("^[ \t└─]*(.+%.exs|.+%.ex):(%d+):(%d+):%s*(.+)$")
    if path and lnum then
      table.insert(qf_items, { filename = path, lnum = tonumber(lnum), col = tonumber(col), text = msg })
      goto continue
    end

    -- Last fallback: add raw line into quickfix with no filename (so it appears but isn't jumpable)
    table.insert(qf_items, { filename = "", lnum = 0, text = raw })
    ::continue::
  end

  return qf_items
end

local function run_cmd_to_quickfix(cmd)
  -- Run command synchronously and populate quickfix list with parsed entries
  -- vim.fn.systemlist runs the command in the shell and returns list of lines
  -- We prefix with 'set -o pipefail; ' to try to preserve failure status; keep simple for mobile.
  local shell_cmd = cmd
  local lines = vim.fn.systemlist(shell_cmd)

  -- If systemlist returns single line with exit code text on some shells, it's still fine
  local qf_items = parse_and_build_qf(lines)

  if #qf_items == 0 then
    -- If parsing failed to find anything, place raw output as a single quickfix entry
    local joined = table.concat(lines, "\n")
    qf_items = { { filename = "", lnum = 0, text = joined } }
  end

  -- Set quickfix list and open it
  vim.fn.setqflist({}, " ", { title = cmd, items = qf_items })
  -- Open quickfix window but keep focus in previous window (open in bottom)
  vim.cmd("copen")
  -- Move cursor to first entry if any meaningful (skip entries with no filename)
  local first_valid = nil
  for i, item in ipairs(qf_items) do
    if item.filename ~= "" and item.lnum and item.lnum > 0 then
      first_valid = i
      break
    end
  end
  if first_valid then
    vim.cmd("cc " .. (first_valid - 1)) -- 0-based internally; cc uses idx
  end

  -- Also print a short message
  print(string.format("Ran: %s  — quickfix contains %d items", cmd, #qf_items))
end

-- Mix helpers: run mix command and populate quickfix
local function run_mix_test()
  -- Prefer to run in project root; user expects to run from cwd
  run_cmd_to_quickfix("mix test")
end

local function run_mix_consistency()
  run_cmd_to_quickfix("mix consistency")
end

-- Mix commands keymaps (replace the old shell-! mappings so results go to quickfix)
vim.keymap.set("n", "<leader>mt", run_mix_test, { desc = "Run mix test and populate quickfix" })
vim.keymap.set("n", "<leader>mc", run_mix_consistency, { desc = "Run mix consistency and populate quickfix" })

-- Phoenix-specific shortcuts
vim.keymap.set("n", "<leader>ps", "<cmd>!mix phx.server<cr>", { desc = "Start Phoenix server" })
vim.keymap.set("n", "<leader>pt", "<cmd>!MIX_ENV=test iex --dot-iex \"test/start_test_server.exs\" -S mix<cr>", { desc = "Start Test server" })

-- If you prefer to also keep the older behavior of running the commands in a terminal,
-- you can add additional mappings (optional). I kept them unbound to avoid duplicate keys.
-- Example (uncomment to enable):
-- vim.keymap.set("n", "<leader>MT", "<cmd>ToggleTerm direction=float cmd='mix test'<CR>", { desc = "Run mix test in terminal" })
-- vim.keymap.set("n", "<leader>MC", "<cmd>ToggleTerm direction=float cmd='mix consistency'<CR>", { desc = "Run mix consistency in terminal" })

print("Neovim config loaded successfully!")

