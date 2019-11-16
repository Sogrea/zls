#!/bin/sh
mkdir ../../.config/i3 2> /dev/null
mkdir ../../.config/kitty 2> /dev/null
mkdir ../../.config/polybar 2> /dev/null
cp -rf ../dotfiles/i3/* ../../.config/i3/
cp -rf ../dotfiles/kitty/* ../../.config/kitty/
cp -rf ../dotfiles/polybar/* ../../.config/polybar/
cp -rf ../dotfiles/zsh/.zshrc ../../
cp -rf ../dotfiles/vim/.vimrc ../../
cp -rf ../dotfiles/alias/.aliasrc ../../
cp -rf ../dotfiles/mirrorlist/.get_updated_mirrirlist.sh ../../

chmod 700 ../../.get_updated_mirrirlist.sh