{ pkgs, ... }:
pkgs.writeShellScriptBin "create-dev-environment" ''
  ${pkgs.zellij}/bin/zellij kill-all-sessions -y;
  ${pkgs.zellij}/bin/zellij  delete-all-sessions -y;
  ${pkgs.docker}/bin/docker stop some-redis;
  ${pkgs.docker}/bin/docker stop awesome;
''
