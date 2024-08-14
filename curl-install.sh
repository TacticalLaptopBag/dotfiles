#!/bin/bash -e

OLD_CWD=`pwd`

git clone git@github.com:TacticalLaptopBag/dotfiles.git ~/.files/ || git clone https://github.com/TacticalLaptopBag/dotfiles.git ~/.files/
cd ~/.files/
./setup.sh

cd "$OLD_CWD"
