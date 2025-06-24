#!/bin/zsh
ACTIVE_COLOR=$1
INACTIVE_COLOR=$2
WIDTH=$3


result=$(borders blacklist=Launchbar\
    active_color="0xFF$ACTIVE_COLOR"\
    inactive_color="0xFF$INACTIVE_COLOR"\
    width="$WIDTH" hidpi=on);

# Debugging
# echo "\n$PATH" >> ~/Desktop/borders.txt
# echo "\n$SHELL" >> ~/Desktop/borders.txt
# echo "\n$?" >> ~/Desktop/borders.txt
