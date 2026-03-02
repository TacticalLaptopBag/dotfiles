#!/bin/bash
set -e

if [ -z $SKIP_SYSTEM_SH ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while true; do
        read -rp "Would you like to run system.sh first? (y/n): " run_init
        case "$run_init" in
            y) sudo "$SCRIPT_DIR/system.sh"; break ;;
            n) break ;;
            *) ;;
        esac
    done
fi

# Ensure path
export PATH="$PATH:$HOME/.local/bin"

# Pipx tools
echo
echo "Installing nifty pipx utils..."
echo "-------------------------------------------------------------------------"
pipx install uv git-profile

# nvm
if ! command -v nvm >& /dev/null; then
    echo
    echo "Installing nvm..."
    echo "-------------------------------------------------------------------------"
    NVM_LATEST=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_LATEST}/install.sh" | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install --lts
    nvm use --lts
fi

# Lazygit
if ! command -v lazygit >& /dev/null; then
    echo
    echo "Installing lazygit..."
    echo "-------------------------------------------------------------------------"
    LAZYGIT_LATEST=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    wget https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_LATEST}/lazygit_${LAZYGIT_LATEST:1}_linux_x86_64.tar.gz -O /tmp/lazygit.tar.gz
    mkdir /tmp/lazygit
    tar xzf /tmp/lazygit.tar.gz -C /tmp/lazygit
    mv /tmp/lazygit/lazygit $HOME/.local/bin
    rm -rf /tmp/lazygit.tar.gz /tmp/lazygit/
fi

# Neovim
if ! command -v nvim >& /dev/null; then
    echo
    echo "Installing neovim..."
    echo "-------------------------------------------------------------------------"
    NEOVIM_LATEST=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    NEOVIM_NAME=nvim-linux-x86_64.appimage
    mkdir -p $HOME/Applications
    wget https://github.com/neovim/neovim/releases/download/$NEOVIM_LATEST/$NEOVIM_NAME -O $HOME/Applications/$NEOVIM_NAME
    chmod +x $HOME/Applications/$NEOVIM_NAME
    rm -f $HOME/.local/bin/nvim
    ln -s $HOME/Applications/$NEOVIM_NAME $HOME/.local/bin/nvim
fi

# SSH Key
if [ ! -f $HOME/.ssh/id_* ]; then
    echo
    echo "Generating SSH key..."
    echo "-------------------------------------------------------------------------"
    ssh-keygen -f $HOME/.ssh/id_ed25519 -t ed25519 -N ''
fi

# Flatpaks
echo
echo "Installing flatpaks..."
echo "-------------------------------------------------------------------------"
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak --user install -y \
    com.github.tchx84.Flatseal \
    com.obsproject.Studio \
    com.usebottles.bottles \
    io.freetubeapp.FreeTube \
    io.github.alainm23.planify \
    org.audacityteam.Audacity \
    org.gnome.GTG \
    org.kde.isoimagewriter \
    org.kde.kdenlive \
    org.keepassxc.KeePassXC \
    org.libreoffice.LibreOffice \
    org.mozilla.Thunderbird \
    ch.protonmail.protonmail-bridge


# Git profiles
echo
echo "Configure your git profiles:"
echo "-------------------------------------------------------------------------"
declare -A git_profile_names
declare -A git_profile_users
declare -A git_profile_emails
profile_order=()

while true; do
    read -rp "Enter a git profile name (or done if finished): " profile_name
    [[ "$profile_name" == "done" ]] && break
    read -rp "Enter username: " profile_user
    read -rp "Enter email: " profile_email
    git_profile_names["$profile_name"]="$profile_name"
    git_profile_users["$profile_name"]="$profile_user"
    git_profile_emails["$profile_name"]="$profile_email"
    profile_order+=("$profile_name")
done

for profile in "${profile_order[@]}"; do
    printf '[%s.user]\n  name = "%s"\n  email = "%s"\n' \
        "$profile" \
        "${git_profile_users[$profile]}" \
        "${git_profile_emails[$profile]}" \
        >> $HOME/.gitconfig
done

echo "Git profiles created in $HOME/.gitconfig"

echo
echo "All done!"
