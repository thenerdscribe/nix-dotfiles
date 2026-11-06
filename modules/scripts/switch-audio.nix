{ pkgs, ... }:
pkgs.writeShellScriptBin "switch-audio" ''
  CURRENT="$(${pkgs.pulseaudio}/bin/pactl list cards | awk -F ':' '/Card/ {match($0, /[0-9]+/, card)}; /Active Profile: output/ {print card[0]","$3; exit 0}')";
  echo $CURRENT;
  IFS=,
  read CARD PROFILE <<< $CURRENT

  if [[ ! -n $PROFILE ]] then
      exit;
  fi

  if [[ $PROFILE = "analog-stereo" ]] then
      NEW="iec958";
  else
      NEW="analog";
  fi

  echo "Switching to: $NEW";
  ${pkgs.pulseaudio}/bin/pactl set-card-profile $CARD "output:$NEW-stereo";
''
