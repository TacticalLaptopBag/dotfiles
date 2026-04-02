#!/bin/bash

# Sanity checks
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo"
    exit 1
fi

which apt-get > /dev/null
if [ "$?" != "0" ]; then
    echo "This script can only run under Debian-based distros!"
    exit 1
fi

set -e


# ==============================================================================
# ================================== PACKAGES ==================================
# ==============================================================================

echo
echo "Installing packages..."
echo "-------------------------------------------------------------------------"
apt-get update
# Use vim-gtk3 for clipboard support
apt-get install \
        apt-transport-https \
        python3 \
        python3-venv \
        python3-pip \
        python-is-python3 \
        pipx \
        rustup \
        openjdk-25-jdk \
        vim-gtk3 \
        curl \
        wget \
        build-essential \
        tmux \
        zsh \
        git \
        gnupg \
        gpg \
        ca-certificates \
        libfuse2 \
        vlc \
        flatpak \
        stow

# Brave
echo
echo "Installing Brave..."
echo "-------------------------------------------------------------------------"
curl -fsS https://dl.brave.com/install.sh | sh

# VS Code
echo
echo "Installing VS Code..."
echo "-------------------------------------------------------------------------"
apt-get install wget gpg &&
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&
install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
rm -f microsoft.gpg
echo "Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg" > /etc/apt/sources.list.d/vscode.sources
apt-get update
apt-get install code

# Docker
echo
echo "Installing Docker..."
echo "-------------------------------------------------------------------------"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# JetBrains Toolbox
echo
echo "Installing JetBrains Toolbox..."
echo "-------------------------------------------------------------------------"
JB_URL=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['TBA'][0]['downloads']['linux']['link'])")
curl -L "$JB_URL" -o /tmp/jetbrains-toolbox.tar.gz
sudo rm -rf /opt/jetbrains-toolbox
mkdir -p /opt/jetbrains-toolbox
tar xzf /tmp/jetbrains-toolbox.tar.gz --strip-components=1 -C /opt/jetbrains-toolbox
rm /tmp/jetbrains-toolbox.tar.gz

cat > /usr/share/applications/jetbrains-toolbox.desktop <<'EOF'
[Desktop Entry]
Name=JetBrains Toolbox
Comment=Manage your JetBrains IDEs
Exec=/opt/jetbrains-toolbox/bin/jetbrains-toolbox
Icon=/opt/jetbrains-toolbox/bin/toolbox-tray-color.png
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=jetbrains-toolbox
EOF

# Nerd Fonts
echo
echo "Downloading and installing Nerd Fonts..."
echo "-------------------------------------------------------------------------"
NERDFONTS_LATEST=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
NERDFONTS_DIR=/tmp/nerdfonts
rm -rf ${NERDFONTS_DIR}
mkdir ${NERDFONTS_DIR}
function download_font {
    if [ -z $2 ]; then
        FILE_PREFIX=$1
    else
        FILE_PREFIX=$2
    fi
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_LATEST}/$1.zip -O ${NERDFONTS_DIR}/$1.zip
    mkdir ${NERDFONTS_DIR}/$1
    unzip ${NERDFONTS_DIR}/$1.zip -d ${NERDFONTS_DIR}/$1
    FONT_NAME="${FILE_PREFIX}NerdFont-Regular.*"
    cp ${NERDFONTS_DIR}/$1/$FONT_NAME /usr/share/fonts
}
download_font ComicShannsMono
download_font DroidSansMono DroidSansM
download_font JetBrainsMono
download_font RobotoMono
download_font Ubuntu
download_font UbuntuSans
download_font UbuntuMono
rm -r ${NERDFONTS_DIR}
echo "Updating font cache..."
fc-cache -f

# AppImageLauncher
# Their binary naming scheme is too complicated :(
echo
echo "Installing AppImageLauncher..."
echo "-------------------------------------------------------------------------"
curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest \
    | grep -o 'https://[^"]*_amd64\.deb' \
    | xargs curl -Lo /tmp/appimagelauncher.deb
apt-get install -y /tmp/appimagelauncher.deb

# ==============================================================================
# =============================== CONFIGURATION ================================
# ==============================================================================

# Groups
echo
echo "Adding you to groups..."
echo "-------------------------------------------------------------------------"
usermod -aG docker,dialout,uucp,tty $USER

echo
echo "All done!"
echo

echo
echo "Some configuration to-dos:"
echo "  * Restart"
echo "  * Sign into VS Code"
echo "  * Sign into JetBrains Toolbox"
echo "  * Install JetBrains IDEs and configure one, import the rest"
echo "  * Install and configure yakuake/ddterm/guake"
echo "  * Run user.sh, if /home hasn't already been setup"
