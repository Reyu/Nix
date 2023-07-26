{ config, pkgs, ... }: {

  programs.autorandr = {
    enable = true;
    profiles = {
      "home" = {
        fingerprint = {
          DisplayPort-0 = builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff001e6d4a776cb90800051f010380502178eaf4f4af4e42ac26
            0e50542109007140818081c0a9c0b300d1c08100d1cf30b870e0d0a04a503020
            3a00204f3100001a000000fd0030781e8239000a202020202020000000fc004c
            4720554c545241474541520a000000ff003130354e544a4a47543735360a013b
            020350f1230907074c1004031f13125d5e5f60613f830100006d030c001000b8
            3c20006001020368d85dc40178800300e30f00066d1a0000020530780004613d
            613de305c000e2006ae606050161613d336970aad0a0345030203a00204f3100
            001a6fc200a0a0a05550302035007a843100001a000000000000000000000013'';

          DisplayPort-1 = builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff0004728f046ce95082191c0103803c22780eee91a3544c9926
            0f505421080001010101010101010101010101010101565e00a0a0a029503020
            350055502100001a000000ff005434544141303038383530320a000000fd0018
            3c1e8c1e010a202020202020000000fc00584232373148550a20202020200130
            02031ac147901f0413031201230907018301000065030c001000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000000000000c1'';

          DisplayPort-2 = builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff0004728f0469e95082191c0103803c22780eee91a3544c9926
            0f505421080001010101010101010101010101010101565e00a0a0a029503020
            350055502100001a000000ff005434544141303038383530320a000000fd0018
            3c1e8c1e010a202020202020000000fc00584232373148550a20202020200133
            02031ac147901f0413031201230907018301000065030c001000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000000000000c1'';
        };
        config = {
          DisplayPort-0 = {
            crtc = 0;
            enable = true;
            mode = "3440x1440";
            position = "2560x0";
            primary = true;
            rate = "85.00";
          };

          DisplayPort-1 = {
            crtc = 1;
            enable = true;
            mode = "2560x1440";
            position = "0x0";
            rate = "59.95";
          };

          DisplayPort-2 = {
            enable = true;
            crtc = 2;
            mode = "2560x1440";
            position = "6000x0";
            rate = "59.95";
          };
        };
      };
    };
  };

  systemd.user.services = {
    autorandr = {
      Unit = {
        Description = "autorandr execution hook";
        StartLimitIntervalSec = "5";
        StartLimitBurst = "1";
      };
      Service = {
        ExecStart = "${pkgs.autorandr}/bin/autorandr --change --default home";
        After = "sleep.target";
        Type = "oneshot";
        RemainAfterExit = "false";
        KillMode = "process";
      };
      Install = { WantedBy = [ "graphical-session.target" "sleep.target" ]; };
    };
  };
}
