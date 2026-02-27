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

echo "Installing packages..."
apt-get update
apt-get install \
        apt-transport-https \
        python3 \
        python3-venv \
        python-is-python3 \
        pipx \
        vim \
        curl \
        wget \
        build-essential \
        tmux \
        zsh \
        git \
        gnupg \
        gpg \
        ca-certificates \
        libfuse2

# Brave
echo "Installing Brave..."
curl -fsS https://dl.brave.com/install.sh | sh

# VS Code
echo "Installing VS Code..."
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
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# JetBrains Toolbox
echo "Installing JetBrains Toolbox..."
JB_URL=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['TBA'][0]['downloads']['linux']['link'])")
curl -L "$JB_URL" -o /tmp/jetbrains-toolbox.tar.gz
mkdir -p /opt/jetbrains-toolbox
tar xzf /tmp/jetbrains-toolbox.tar.gz --strip-components=1 -C /opt/jetbrains-toolbox
rm /tmp/jetbrains-toolbox.tar.gz

cat > /usr/share/applications/jetbrains-toolbox.desktop <<'EOF'
[Desktop Entry]
Name=JetBrains Toolbox
Comment=Manage your JetBrains IDEs
Exec=/opt/jetbrains-toolbox/jetbrains-toolbox
Icon=jetbrains-toolbox
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=jetbrains-toolbox
EOF

# Nerd Fonts
echo "Downloading and installing Nerd Fonts..."
NERDFONTS_LATEST=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
NERDFONTS_DIR=/tmp/nerdfonts
mkdir ${NERDFONTS_DIR}
function download_font {
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_LATEST}/$1.zip -O ${NERDFONTS_DIR}/$1.zip
    mkdir ${NERDFONTS_DIR}/$1
    unzip ${NERDFONTS_DIR}/$1.zip -d ${NERDFONTS_DIR}/$1
    FONT_NAME="${1}NerdFont-Regular.ttf"
    cp ${NERDFONTS_DIR}/$1/$FONT_NAME /usr/share/fonts
}
download_font ComicShannsMono
download_font DroidSansMono
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
curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest \
    | grep -o 'https://[^"]*_amd64\.deb' \
    | xargs curl -Lo /tmp/appimagelauncher.deb
apt-get install /tmp/appimagelauncher.deb

# ==============================================================================
# =============================== CONFIGURATION ================================
# ==============================================================================

# Groups
echo "Adding you to groups..."
usermod -aG docker,dialout $USER

echo
echo "All done!"
echo

if [ -z $SKIP_USER_SH ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while true; do
        read -rp "Would you like to run user.sh now? (y/n): " run_init
        case "$run_init" in
            y) su $USER -c "$SCRIPT_DIR/user.sh"; break ;;
            n) break ;;
            *) ;;
        esac
    done
fi

echo "Some configuration to-dos:"
echo "  * Restart"
echo "  * Sign into VS Code"
echo "  * Sign into JetBrains Toolbox"
echo "  * Install JetBrains IDEs and configure one, import the rest"
echo "  * Install and configure yakuake/ddterm/guake"
echo "  * Run user.sh, if /home hasn't already been setup"
