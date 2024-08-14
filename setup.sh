#!/bin/bash

verify_command() {
  which $1 > /dev/null
  if [ "$?" != "0" ]; then
    echo "Command '$1' is not installed!"
    exit 1
  fi
}

verify_command git
verify_command stow
set -e

echo "Replacing dotfiles..."
stow --adopt --dotfiles .
echo "Restoring dotfiles in stow directory..."
git reset --hard HEAD

echo "Dotfiles are setup!"

