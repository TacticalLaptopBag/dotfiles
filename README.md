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

