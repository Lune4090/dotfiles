#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper
swww img ~/Pictures/w1.jpg &

# nm-applet needs pkgs.networkmanagerapplet to the packages
# nm-applet --indicator &

# bar
waybar &

# mako
mako &

# fcitx5
fcitx5 &
