#!/bin/bash -e

git clone git@github.com:TacticalLaptopBag/dotfiles.git ~/.files/ || git clone https://github.com/TacticalLaptopBag/dotfiles.git
~/.files/setup.sh

