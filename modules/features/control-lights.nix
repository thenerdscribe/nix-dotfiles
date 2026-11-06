{ pkgs, ... }:
let
  sleepTargets = [
    "suspend.target"
    "hibernate.target"
    "hybrid-sleep.target"
    "suspend-then-hibernate.target"
  ];
  hookOn =
    state:
    pkgs.writeShellScript "lights-${state}" ''
      for i in $(seq 1 15); do
        ${pkgs.curl}/bin/curl -fsS -m 3 \
          "http://100.110.226.86:51828/?accessoryId=pcAwake&state=${state}" && exit 0
        sleep 2
      done
    '';
  hookOff =
    state:
    pkgs.writeShellScript "lights-${state}" ''
      sleep 5;
      ${pkgs.curl}/bin/curl -fsS -m 3 \
          "http://100.110.226.86:51828/?accessoryId=pcAwake&state=${state}" && exit 0
    '';
in
{
  systemd.services.lights-on-after-resume = {
    description = "Turn HomeKit lights on after resume";
    wantedBy = sleepTargets;
    after = sleepTargets;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = hookOn "true";
    };
  };
}
