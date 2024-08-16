# dotfiles

## Setup

Ensure `git` and `stow` are installed.

```commandline
curl -L https://raw.githubusercontent.com/TacticalLaptopBag/dotfiles/main/curl-install.sh | bash
```

Or, alternatively:
```commandline
git clone https://github.com/TacticalLaptopBag/dotfiles.git ~/.files
cd ~/.files
./setup.sh
```

## Updating Config
If you add things to the `~/.files/` directory, you should run these commands:

```commandline
cd ~/.files
./update.sh
```

## Neovim Config
Neovim config is based on [NvChad v2.0](https://github.com/NvChad/NvChad/tree/v2.0).

Useful keybinds (`⎵` is spacebar, `⌥` is alt/option, `<C-a>` is CTRL+A):
- `⎵e`: Focus file tree
- `<C-n>`: Toggle file tree
- `<C-n>` (in autocomplete): Next autocomplete item
- `<C-p>` (in autocomplete): Previous autocomplete item
- `⌥h`: Toggle horizontal terminal
- `⌥v`: Toggle vertical terminal
- `⌥i`: Toggle floating terminal
- `⎵ca`: Code action (Similar to VS Code's Quick Fix)
- `⎵ch`: Cheatsheet (All keybinds)
- `⎵ff`: Find file
- `⎵fb`: Find open buffer
- `⎵fz`: Find in current buffer
- `⎵fw`: Find in all files (requires `ripgrep` to be installed)
- `⎵ra`: Refactor
- `⎵th`: Change theme
- `K`: LSP Hover
- `>>`: Indent right
- `<<`: Indent left
- `^`: Start of line, non-whitespace
- `~`: Toggle case
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation
- `gr`: Go to references
- `gf`: Go to file under cursor
- `g<C-G>`: Show current column, line, word, and byte
- `H`: Top (Home) of screen
- `L`: Bottom (Last line) of screen
- `]]`: Next method
- `[[`: Previous method
- `]d`: Next diagnostic message
- `[d`: Previous diagnostic message
- `⎵gb`: Git Blame current line
- `⎵gt`: Git status
- `H` (in filetree): Toggle hidden files

## Tmux Config

Useful keybinds (`<>` is prefix, which is currently `<C-a>`):
- `<>z`: Toggle pane zoom
- `<>,`: Rename pane

