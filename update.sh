#!/bin/bash

verify_command() {
  which $1 > /dev/null
  if [ "$?" != "0" ]; then
    echo "Command '$1' is not installed!"
    exit 1
  fi
}

verify_command stow
set -e

echo "Updating dotfiles..."
stow --dotfiles .

if [ "$#" != "1" ]; then
  echo "Add an argument to automatically commit to git: $0 \"<git-commit-msg>\""
  exit 0
fi

if [ ! -z "$(git status --porcelain)" ]; then
  git add .
  git commit -m "$1"
fi

