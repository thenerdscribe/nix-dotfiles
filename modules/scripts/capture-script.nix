{ pkgs, ... }:
pkgs.writeShellScriptBin "capture-script" ''
  set -euo pipefail
  mkdir -p "$HOME/Pictures/Screenshots"
  filepath="$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"

  case "''${1:-fullscreen}" in
    region)
      g=$(${pkgs.slurp}/bin/slurp -d); [ -z "$g" ] && exit 1
      ${pkgs.grim}/bin/grim -g "$g" "$filepath" ;;
    window)
      g=$(${pkgs.mango}/bin/mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
      [ -z "$g" ] && exit 1
      ${pkgs.grim}/bin/grim -g "$g" "$filepath" ;;
    freeze)
      p=$(mktemp -u).fifo; mkfifo "$p"
      ${pkgs.wayfreeze}/bin/wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
      read -r < "$p"; ${pkgs.grim}/bin/grim "$filepath"
      kill "$wp" 2>/dev/null; rm -f "$p" ;;
    freeze-region)
      p=$(mktemp -u).fifo; mkfifo "$p"
      ${pkgs.wayfreeze}/bin/wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
      read -r < "$p"; g=$(${pkgs.slurp}/bin/slurp -d)
      if [ -z "$g" ]; then kill "$wp" 2>/dev/null; rm -f "$p"; exit 1; fi
      ${pkgs.grim}/bin/grim -g "$g" "$filepath"
      kill "$wp" 2>/dev/null; rm -f "$p" ;;
    annotate)
      ${pkgs.grim}/bin/grim "$filepath"; satty --filename "$filepath" --output-filename "$filepath" --actions-on-enter save-to-file --early-exit ;;
    *) ${pkgs.grim}/bin/grim "$filepath" ;;
  esac
''
