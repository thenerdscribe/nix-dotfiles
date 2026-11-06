{ pkgs, ... }:
pkgs.writeShellScriptBin "create-dev-environment" ''
  ${pkgs.zellij}/bin/zellij kill-all-sessions -y;
  ${pkgs.zellij}/bin/zellij  delete-all-sessions -y;
  sessions='tools ospos ordermanager pos-1 inventory awesome';
  for session in $sessions;
  do
   ${pkgs.zellij}/bin/zellij --layout $session attach -b $session;
  done;
  ${pkgs.docker}/bin/docker start some-redis;
  ${pkgs.docker}/bin/docker start awesome;
''
