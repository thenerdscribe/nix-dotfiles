{ pkgs, ... }:
pkgs.writeShellScriptBin "toggle-music" ''
  match=`${pkgs.niri}/bin/niri msg -j windows | ${pkgs.jq}/bin/jq '.[] | select(.title == "RMPC Music") | .id'`;

  if [[ $match == "" ]]; then
      ${pkgs.niri}/bin/niri msg action spawn -- ghostty --title="RMPC Music" -e "rmpc";
  else
      ${pkgs.niri}/bin/niri msg action close-window --id=$match;
  fi
''
