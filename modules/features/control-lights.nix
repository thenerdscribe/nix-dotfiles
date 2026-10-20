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
      # Retry: Wi-Fi may take a few seconds to come back after resume
      for i in $(seq 1 15); do
        ${pkgs.curl}/bin/curl -fsS -m 3 \
          "http://100.110.226.86:51828/?accessoryId=pcAwake&state=${state}" && exit 0
        sleep 2
      done
    '';
  hookOff =
    state:
    pkgs.writeShellScript "lights-${state}" ''
      # Retry: Wi-Fi may take a few seconds to come back after resume
        sleep 5;
        ${pkgs.curl}/bin/curl -fsS -m 1 "http://100.110.226.86:51828/?accessoryId=pcAwake&state=${state}" && exit 0
    '';
in
{
  systemd.services.lights-off-before-sleep = {
    description = "Turn HomeKit lights off before suspend";
    wantedBy = sleepTargets;
    before = sleepTargets;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = hookOff "false";
    };
  };

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
