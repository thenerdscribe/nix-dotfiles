{ pkgs, ... }:
pkgs.writeShellScriptBin "toggle-taskwarrior" ''
  match=`${pkgs.niri}/bin/niri msg -j windows | ${pkgs.jq}/bin/jq '.[] | select(.title == "Taskwarrior TUI") | .id'`;

  if [[ $match == "" ]]; then
      ${pkgs.niri}/bin/niri msg action spawn -- ghostty --title="Taskwarrior TUI" -e "taskwarrior-tui";
  else
      ${pkgs.niri}/bin/niri msg action close-window --id=$match;
  fi
''
