#!/bin/sh
mkdir ../../.config/i3 2> /dev/null
mkdir ../../.config/kitty 2> /dev/null
mkdir ../../.config/polybar 2> /dev/null
mkdir ../../.config/rofi 2> /dev/null
mkdir ../../.config/picom 2> /dev/null

cp -rf ../dotfiles/i3/* ../../.config/i3/
cp -rf ../dotfiles/kitty/* ../../.config/kitty/
cp -rf ../dotfiles/polybar/* ../../.config/polybar/
cp -rf ../dotfiles/zsh/.zshrc ../../
cp -rf ../dotfiles/vim/.vimrc ../../
cp -rf ../dotfiles/alias/.aliasrc ../../
cp -rf ../dotfiles/mirrorlist/.get_updated_mirrirlist.sh ../../
cp -rf ../dotfiles/intel_driver/20-intel.conf ../../../../etc/X11/xorg.conf.d/
cp -rf ../dotfiles/rofi/* ../../.config/rofi/
cp -rf ../dotfiles/picom/* ../../.config/picom/

chmod +x ../../.get_updated_mirrirlist.sh