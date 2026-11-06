#!/bin/sh
player_status="$(playerctl --player=cmus,spotify status 2> /dev/null)";
artist="$(playerctl --player=cmus,spotify metadata artist | sed 's/&/&amp;/g')";
title=$(playerctl --player=cmus,spotify  metadata title | sed 's/&/&amp;/g');
if [ ${#artist} -gt 10 ]; then
    artist="$(echo $artist | cut -c 1-9)..."
fi

if [ ${#title} -gt 10 ]; then
    title="$(echo $title | cut -c 1-9)..."
fi

if [ "$player_status" = "Playing" ]; then
    SYMBOL="";
elif [ "$player_status" = "Paused" ]; then
    SYMBOL="  ";
fi

echo "$SYMBOL$artist - $title";
