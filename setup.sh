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
    which node > /dev/null

    # Sometimes, Node isn't installed through apt. If it isn't installed at all, it's probably safe to use apt.
    NODE_DEPENDS=""
    if [ "$?" != "0" ]; then
      NODE_DEPENDS="node npm"
    fi
    sudo apt-get update -y
    sudo apt-get install python3 python3-venv git stow $NODE_DEPENDS
  fi
}

try_install_depends

verify_command git
verify_command stow
verify_command npm
verify_command node
set -e

echo "Replacing dotfiles..."
stow --adopt --dotfiles .
echo "Restoring dotfiles in stow directory..."
git reset --hard HEAD

echo "Dotfiles are setup!"

