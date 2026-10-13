#!/bin/bash
set -e

# Sanity checks
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run with sudo"
    exit 1
fi

if ! which apt-get > /dev/null; then
    echo "This script can only run under Debian-based distros!"
    exit 1
fi


# ==============================================================================
# ================================== PACKAGES ==================================
# ==============================================================================

echo
echo "Installing packages..."
echo "-------------------------------------------------------------------------"

# Need curl and wget to add repositories
echo "Installing curl and wget..."
apt-get update
apt-get install -yqq curl wget

# ungoogled-chromium
echo "Adding XtraDeb repository..."
TMP_F="$(mktemp "${TMPDIR:-/tmp}/xtradeb-XXXXXX.deb")"
wget https://launchpad.net/~xtradeb/+archive/ubuntu/apps/+files/xtradeb-apt-source_0.6_all.deb
apt-get install -yqq "$TMP_F"

# codium
echo "Adding VS Codium repository..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
    | tee /etc/apt/sources.list.d/vscodium.sources

# docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Adding Docker repository..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# yazi
echo "Adding yazi repository..."
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | tee /etc/apt/sources.list.d/yazi.list >/dev/null

echo "Installing system packages..."
# Use vim-gtk3 for clipboard support
apt-get install -yqq \
    apt-transport-https \
    python3 \
    python3-venv \
    python3-pip \
    python-is-python3 \
    pipx \
    rustup \
    openjdk-25-jdk \
    vim-gtk3 \
    build-essential \
    tmux \
    zsh \
    git \
    git-lfs \
    gnupg \
    gpg \
    ca-certificates \
    libfuse2 \
    vlc \
    flatpak \
    stow \
    wl-clipboard \
    kitty \
    jq \
    ripgrep \
    fd-find \
    fzf \
    zoxide \
    resvg \
    imagemagick \
    codium \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    ungoogled-chromium \
    golang \
    yazi

# JetBrains Toolbox
echo
echo "Installing JetBrains Toolbox..."
echo "-------------------------------------------------------------------------"
JB_URL=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['TBA'][0]['downloads']['linux']['link'])")
curl -L "$JB_URL" -o /tmp/jetbrains-toolbox.tar.gz
rm -rf /opt/jetbrains-toolbox
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

# Balena Etcher
echo
echo "Installing Balena Etcher..."
echo "-------------------------------------------------------------------------"

# Find Balena download URL
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/balena-io/etcher/releases/latest \
  | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url')

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" == "null" ]; then
    echo "Could not find Balena's .deb package in the latest release."
else
  # Create a temporary file ending in .deb
  # (apt sometimes prefers the .deb extension to recognize the file type)
  TEMP_DEB=$(mktemp "${TMPDIR:-/tmp}/etcher-XXXXXX.deb")

  # Ensure the temp file is deleted on exit, even if the script fails
  trap 'rm -f "$TEMP_DEB"' EXIT

  echo "Downloading to temporary file: $TEMP_DEB"
  curl -L "$DOWNLOAD_URL" -o "$TEMP_DEB"

  # Install the downloaded package
  echo "Installing Balena Etcher..."
  apt-get install -yqq "$TEMP_DEB"
fi

# Firefox deb
echo "Removing Firefox snap and installing deb Firefox..."
echo "-------------------------------------------------------------------------"
# Source: https://linuxcapable.com/how-to-remove-firefox-snap-from-ubuntu-linux/
snap remove --purge firefox
TMP_F="$(mktemp)"
wget -O "$TMP_F" https://packages.mozilla.org/apt/repo-signing-key.gpg
install -d -m 0755 /etc/apt/keyrings
install -m 0644 "$TMP_F" /etc/apt/keyrings/packages.mozilla.org.asc
rm -f packages.mozilla.org.asc

printf '%s\n' \
'Types: deb' \
'URIs: https://packages.mozilla.org/apt' \
'Suites: mozilla' \
'Components: main' \
'Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc' \
| tee /etc/apt/sources.list.d/mozilla.sources > /dev/null

printf '%s\n' \
'Package: firefox*' \
'Pin: release o=Ubuntu*' \
'Pin-Priority: -1' \
| tee /etc/apt/preferences.d/firefox-no-snap > /dev/null

printf '%s\n' \
'Package: *' \
'Pin: origin packages.mozilla.org' \
'Pin-Priority: 1000' \
| tee /etc/apt/preferences.d/mozilla > /dev/null

apt-get update
apt-get install -yqq firefox

echo "Disabling unattended upgrades..."
echo "-------------------------------------------------------------------------"
systemctl disable --now unattended-upgrades

# Nerd Fonts
echo
echo "Downloading and installing Nerd Fonts..."
echo "-------------------------------------------------------------------------"
NERDFONTS_LATEST=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
NERDFONTS_DIR=/tmp/nerdfonts
rm -rf ${NERDFONTS_DIR}
mkdir ${NERDFONTS_DIR}
function download_font {
    if [ -z "$2" ]; then
        FILE_PREFIX=$1
    else
        FILE_PREFIX=$2
    fi
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_LATEST}/$1.zip" -O "${NERDFONTS_DIR}/$1.zip"
    mkdir "${NERDFONTS_DIR}/$1"
    unzip "${NERDFONTS_DIR}/$1.zip" -d "${NERDFONTS_DIR}/$1"
    FONT_NAME="${FILE_PREFIX}NerdFont-Regular.*"
    cp "${NERDFONTS_DIR}/$1/$FONT_NAME" /usr/share/fonts
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

# ==============================================================================
# =============================== CONFIGURATION ================================
# ==============================================================================

# Groups
echo
echo "Adding you to groups..."
echo "-------------------------------------------------------------------------"
usermod -aG docker,dialout,uucp,tty "$USER"

echo
echo "All done!"
echo

echo
echo "Some configuration to-dos:"
echo "  * Restart"
echo "  * Setup VS Codium Sync Settings"
echo "  * Sign into JetBrains Toolbox"
echo "  * Install JetBrains IDEs and configure one, import the rest"
echo "  * Run user.sh, if /home hasn't already been setup"
