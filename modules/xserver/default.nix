{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.services.xserver;
in {

  options.foxnet.services.xserver = {
    enable = mkEnableOption "X server";
  };

  config = mkIf cfg.enable {

    services.physlock = {
      enable = true;
      #lockOn.extraTargets = [ "display-manager.service" ];
    };
    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      dpi = 125;
      xkbVariant = "dvorak";

      libinput = {
        enable = true;
      };

      config = ''
        Section "InputClass"
        Identifier "mouse accel"
        Driver "libinput"
        MatchIsPointer "on"
        Option "AccelProfile" "flat"
        Option "AccelSpeed" "0"
        EndSection
      '';

      displayManager.autoLogin = {
        enable = true;
        user = "reyu";
      };

      desktopManager = {
        xterm.enable = false;
        session = [{
          name = "home-manager";
          start = ''
             ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }];
      };
    };
  };
}
