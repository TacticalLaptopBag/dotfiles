#!/bin/bash -e

OLD_CWD=`pwd`

git clone git@github.com:TacticalLaptopBag/dotfiles.git ~/.files/ || git clone https://github.com/TacticalLaptopBag/dotfiles.git ~/.files/
cd ~/.files/
git submodule update --init --recursive

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while true; do
    read -rp "Would you like to run system.sh or user.sh? (system/user/both/n): " run_init
    case "$run_init" in
        system) SKIP_USER_SH=1 sudo "$HOME/.files/init/system.sh"; break ;;
        user) SKIP_SYSTEM_SH=1 "$HOME/.files/init/user.sh"; break ;;
        both) SKIP_USER_SH=1 sudo "$HOME/.files/init/system.sh"; SKIP_SYSTEM_SH=1 "$HOME/.files/init/user.sh"; break ;;
        n) break ;;
        *) ;;
    esac
done

./setup.sh

cd "$OLD_CWD"
