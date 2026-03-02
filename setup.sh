#!/bin/bash

verify_command() {
  which $1 > /dev/null
  if [ "$?" != "0" ]; then
    echo "Command '$1' is not installed!"
    exit 1
  fi
}

try_install_depends() {
  which apt-get > /dev/null
  if [ "$?" == "0" ]; then
    echo "apt detected, installing dependencies..."
    sudo apt-get update -y
    sudo apt-get install git stow
  fi
}

try_install_depends

verify_command git
verify_command stow
set -e

echo "Populating git submodules..."
git submodule init
git submodule update

echo "Setting up zsh plugins..."
# TODO: zsh can't update when using links like this...
# Need to find a better way to handle this
rm -rfv .oh-my-zsh/custom/plugins
ln -s ../../zsh-plugins .oh-my-zsh/custom/plugins

echo "Replacing dotfiles..."
stow --adopt --dotfiles .
echo "Restoring dotfiles in stow directory..."
git reset --hard HEAD

echo "Dotfiles are setup!"
