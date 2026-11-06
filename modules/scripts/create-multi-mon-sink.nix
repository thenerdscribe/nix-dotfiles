{ pkgs, ... }:
pkgs.writeShellScriptBin "multimon-target" ''
  ${pkgs.pulseaudio}/bin/pactl load-module module-null-sink sink_name=multimon-target sink_properties=device.description="multimon-target"
''
