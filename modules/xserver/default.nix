{ config, pkgs, lib, ... }:
with lib; {
  config = {
    services.physlock = { enable = true; };
    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      dpi = 125;
      xkbOptions = "caps:escape";

      libinput = { enable = true; };

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
