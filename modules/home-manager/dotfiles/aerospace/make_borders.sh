#!/bin/sh
ACTIVE_COLOR=$1
INACTIVE_COLOR=$2
WIDTH=$3


result=$(borders active_color="0xFF$ACTIVE_COLOR"\
    inactive_color="0xFF$INACTIVE_COLOR"\
    width="$WIDTH" hidpi=on);
echo $? > ~/Desktop/borders.txt
