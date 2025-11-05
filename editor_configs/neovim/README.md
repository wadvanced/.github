# Configuring NEOVIM

## ASDF or brew

I recommend using asdf if already installed.

### Installing using ASDF
```bash
# First the neovim plugin
asdf plugin add neovim
asdf install neovim 0.11.4

# Lua 5.1
asdf plugin add lua
asdf install lua 5.1
```

You might need to install some OS specific dependencies.

### Installing using brew
```bash
brew install neovim
brew install lua
``

## Configuration

The proposed configuration creates a list of mobile compatible shortcuts, detailed [here](./shortcuts.md).

You can use the [init.lua](./init.lua) configuration, please note that there is a SINGLE configuration file.
No plugins, nor Keymaps files. Here are the features included at the current version:


- Session management per start folder
  - When exiting (:qa) the current buffer states are saved
  - When entering the previously stored session state are restored.
- Solarized theme
- Treesitter
- Elixir LSP_CONFIG
- Copilot / Copilot chat
- Autocompletion with LSP and Copilot
- Oil for file exploring
- Telescope for search, buffers, and help tags
- Gitsign for git status
- Neogit for git UI
- Terminal in neovim (no buffer, :terminal is also available)
- Quick list for 'mix test' and 'mix compile'


