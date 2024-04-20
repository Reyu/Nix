{ pkgs, ... }:
{
  config = {
    services.physlock = {
      enable = true;
    };
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "reyu";
        };
        default_session = initial_session;
      };
    };
    services.displayManager.autoLogin = {
      enable = true;
      user = "reyu";
    };
    services.xserver = {
      enable = true;
      autorun = true;
      dpi = 125;
      xkb = {
        options = "caps:escape";
        layout = "us";
      };

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

      desktopManager = {
        xterm.enable = false;
        session = [
          {
            name = "home-manager";
            start = ''
               ${pkgs.runtimeShell} $HOME/.hm-xsession &
              waitPID=$!
            '';
          }
        ];
      };
    };
  };
}
