# Neovim Configuration Reference

## Nomenclature Key

- **Leader**: `<Space>` (primary leader key)
- **Local Leader**: `,` (secondary leader for filetype-specific mappings)
- **C-**: `Ctrl` key (e.g., `C-y` = `Ctrl+y`)
- **M-**: `Meta`/`Alt` key (e.g., `M-]` = `Alt+]`)
- **n**: Normal mode
- **v**: Visual mode
- **i**: Insert mode

## Core Settings

### Basic Editor Configuration
- Line numbers: absolute + relative
- Tab settings: 2 spaces, smart indent
- No wrap, swapfile, or backup
- Persistent undo
- Enhanced colors and UI

### Session Management
Auto-saves/loads sessions per directory in `~/.local/share/nvim/sessions/`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>ss` | Save session for current directory |
| n | `<leader>sl` | Load session for current directory |

## Plugins and Their Keymaps

### 🎨 Color Scheme
**Plugin**: `maxmx03/solarized.nvim`
- Solarized light theme

### 🌳 Syntax Highlighting
**Plugin**: `nvim-treesitter/nvim-treesitter`
- Enhanced syntax for Elixir, Heex, EEx, Lua, JavaScript, HTML, CSS

### 🔧 LSP (Language Server Protocol)
**Plugin**: `neovim/nvim-lspconfig`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>gd` | Go to definition |
| n | `<leader>gr` | Find references |
| n | `<leader>gi` | Go to implementation |
| n | `<leader>K` | Hover documentation |
| n | `<leader>rn` | Rename symbol |
| n | `<leader>ca` | Code actions |
| n | `<leader>e` | Show diagnostic |
| n | `<leader>dn` | Next diagnostic |
| n | `<leader>dp` | Previous diagnostic |

*Auto-format on save for Elixir files*

### 🤖 GitHub Copilot
**Plugin**: `zbirenbaum/copilot.lua`

#### Suggestion Mode
| Mode | Shortcut | Description |
|------|----------|-------------|
| i | `<C-y>` | Accept suggestion |
| i | `<M-]>` | Next suggestion |
| i | `<M-[>` | Previous suggestion |
| i | `<C-]>` | Dismiss suggestion |

#### Panel Mode
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `[[` | Jump to previous |
| n | `]]` | Jump to next |
| n | `<CR>` | Accept |
| n | `gr` | Refresh |
| n | `<M-CR>` | Open panel |

### 💬 Copilot Chat
**Plugin**: `CopilotC-Nvim/CopilotChat.nvim`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>cc` | Toggle Copilot Chat |
| n | `<leader>ce` | Explain code |
| n | `<leader>cr` | Review code |
| n | `<leader>cf` | Fix code |
| n | `<leader>co` | Optimize code |
| n | `<leader>cd` | Generate docs |
| n | `<leader>ct` | Generate tests |
| n | `<leader>cp` | Toggle Copilot |
| v | `<leader>cc` | Chat with selection |

### 🔠 Autocompletion
**Plugin**: `hrsh7th/nvim-cmp`

| Mode | Shortcut | Description |
|------|----------|-------------|
| i | `<C-n>` | Select next item |
| i | `<C-p>` | Select previous item |
| i | `<C-d>` | Scroll docs up |
| i | `<C-f>` | Scroll docs down |
| i | `<C-Space>` | Trigger completion |
| i | `<C-e>` | Abort completion |
| i | `<CR>` | Confirm selection |

### 📁 File Explorer
**Plugin**: `stevearc/oil.nvim`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>o` | Open file explorer |
| n | `<leader>d` | Change to directory under cursor |
| n | `<C-r>` | Refresh file explorer |

### 🔍 Fuzzy Finder
**Plugin**: `nvim-telescope/telescope.nvim`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>ff` | Find files |
| n | `<leader>fg` | Live grep |
| n | `<leader>fb` | Find buffers |
| n | `<leader>fh` | Help tags |

### 📊 Git Integration
**Plugin**: `lewis6991/gitsigns.nvim`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>hn` | Next hunk |
| n | `<leader>hp` | Previous hunk |
| n | `<leader>hs` | Stage hunk |
| n | `<leader>hr` | Reset hunk |
| n | `<leader>hb` | Blame line |

### 🚀 Git Interface
**Plugin**: `NeogitOrg/neogit`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>gg` | Open Neogit |
| n | `<leader>gc` | Git commit |
| n | `<leader>gp` | Git push |
| n | `<leader>gl` | Git pull |

### 📊 Status Line
**Plugin**: `nvim-lualine/lualine.nvim`
- Solarized-themed status line

### 🔄 Auto Pairs
**Plugin**: `windwp/nvim-autopairs`
- Automatic bracket/parenthesis completion

### 💬 Comment Toggling
**Plugin**: `numToStr/Comment.nvim`
- `gcc`: Toggle line comment
- `gbc`: Toggle block comment

### ⚗️ Elixir Tools
**Plugin**: `elixir-tools/elixir-tools.nvim`
- Enhanced Elixir development features

### 💻 Terminal
**Plugin**: `akinsho/toggleterm.nvim`

| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>tt` | Toggle terminal |

## General Keymaps

### File Operations
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>w` | Save file |
| n | `<leader>q` | Quit |
| n | `<leader>x` | Save and quit |

### Buffer Management
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>bn` | Next buffer |
| n | `<leader>bp` | Previous buffer |
| n | `<leader>bd` | Delete buffer |

### Window Management
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>wh` | Window left |
| n | `<leader>wj` | Window down |
| n | `<leader>wk` | Window up |
| n | `<leader>wl` | Window right |
| n | `<leader>ws` | Split horizontal |
| n | `<leader>wv` | Split vertical |

### Utilities
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>nh` | Clear search highlights |
| v | `<` | Indent left |
| v | `>` | Indent right |

## Elixir/Phoenix Development

### Mix Commands
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>mt` | Run mix test (async to quickfix) |
| n | `<leader>mc` | Run mix consistency (async to quickfix) |

### Phoenix Server
| Mode | Shortcut | Description |
|------|----------|-------------|
| n | `<leader>ps` | Start Phoenix server |
| n | `<leader>pt` | Start test server |

## QuickFix Integration

Custom async command runner that:
- Parses command output for file:line:column patterns
- Populates quickfix list automatically
- Opens quickfix window with results
- Supports Elixir compiler/test output format

---

*Configuration optimized for SSH development on mobile devices*



