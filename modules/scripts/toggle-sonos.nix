{ pkgs, ... }:
pkgs.writeShellScriptBin "toggle-sonos" ''
  outputs="$(${pkgs.rmpc}/bin/rmpc outputs)";

  sonos_enabled=`echo $outputs | ${pkgs.jq}/bin/jq '.[] | select(.name == "mp3audio") | .enabled' `;

  sonos_input=`echo $outputs | ${pkgs.jq}/bin/jq '.[] | select(.name == "mp3audio") | .id'`;
  default_input=`echo $outputs | ${pkgs.jq}/bin/jq '.[] | select(.name == "My Default Output") | .id'`;

  if [[ $sonos_enabled == 'true' ]]; then
      ${pkgs.rmpc}/bin/rmpc enableoutput $default_input;
      ${pkgs.rmpc}/bin/rmpc disableoutput $sonos_input;
  else
      ${pkgs.rmpc}/bin/rmpc disableoutput $default_input;
      ${pkgs.rmpc}/bin/rmpc enableoutput $sonos_input;
  fi

''
