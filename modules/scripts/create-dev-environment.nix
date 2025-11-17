{ pkgs, ... }:
pkgs.writeShellScriptBin "create-dev-environment" ''
  zellij kill-all-sessions -y; zellij delete-all-sessions -y;
  sessions=('tools' 'ospos' 'ordermanager' 'pos-1' 'inventory' 'awesome');
  for session in $sessions
  do
   ${pkgs.zellij} --layout $session attach --create $session;
  done
''
