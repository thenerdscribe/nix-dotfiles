#!/bin/sh
player_status=$(playerctl --player=cmus,spotify status 2> /dev/null)
if [ "$player_status" = "Playing" ]; then
    echo "$(playerctl --player=cmus,spotify metadata artist) - $(playerctl --player=cmus,spotify metadata title)"
elif [ "$player_status" = "Paused" ]; then
    echo " $(playerctl --player=cmus,spotify metadata artist) - $(playerctl --player=cmus,spotify metadata title)"
fi
