{ config, lib, pkgs, ... }:

let

  applySuspendBugfixTo =
    services:
    lib.genAttrs services (
      name: {
        environment = {
          SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
        };
      }
    );

in
{
  environment.systemPackages = [
    pkgs.acpi
    pkgs.btop
  ];

  # Power management
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  # ACPI Daemon
  services.acpid.enable = true;

  # CPU power: automated frequency tuning.
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "powersave";
      energy_performance_preference = "balance_performance";
    };
    battery = {
      governor = "powersave";
      energy_performance_preference = "power";
    };
  };

  # CPU power: automated thermal management. Override the stock package
  # from nixpkgs to fix 'failed to read odvpXXXX' bug.
  services.thermald.package = pkgs.thermald.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "RevySR";
      repo = "thermal_daemon";
      rev = "836648db1f23144d35618a781624fe77dde48b03";
      hash = "sha256-4k/MbUE/zyE5S3T3EKOQWq5xjTbQ4+pHK6+wfP1lqmc=";
    };
  };

  # CPU power: disable power-profiles-daemon and TLP to avoid conflicts
  # with thermald and auto-cpufreq.
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp.enable = lib.mkForce false;

  # Suspend-and-hibernate: fix bug causing user sessions to freeze forever.
  systemd.services = applySuspendBugfixTo [
    "systemd-suspend"
    "systemd-hibernate"
    "systemd-hybrid-sleep"
    "systemd-suspend-then-hibernate"
  ];
}
