{ pkgs, ... }:
pkgs.writeShellScriptBin "switch-audio" ''
CURRENT="$(${pkgs.pactl} list cards | awk -F ':' '/Active Profile: output/ {print $3}')";
echo $CURRENT;

if [[ ! -n $CURRENT ]] then
    exit;
fi

if [[ $CURRENT = "analog-stereo" ]] then
    NEW="iec958";
else
    NEW="analog";
fi

echo "Switching to: $NEW";
CARD="$(${pkgs.pactl} list cards | rg Card | tail -n1 | rg -o '\d\d')"
${pkgs.pactl} set-card-profile $CARD "output:$NEW-stereo";
''
