{ config, pkgs, lib, ... }: {

  programs.autorandr = {
    enable = true;
    profiles = {
      "home" = {
        fingerprint = {
          DisplayPort-0 = (builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff0004728f04c5a28081121c0103803c22780eee91a3544c99260f505
            421080001010101010101010101010101010101565e00a0a0a0295030203500555021
            00001a000000ff005434544141303038383530320a000000fd00183c1e8c1e010a202
            020202020000000fc00584232373148550a202020202001f602031ac147901f041303
            1201230907018301000065030c0010000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000c1'');

          DisplayPort-1 = (builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff001e6d4a776cb90800051f010380502178eaf4f4af4e42ac260e505
            42109007140818081c0a9c0b300d1c08100d1cf30b870e0d0a04a5030203a00204f31
            00001a000000fd0030781e8239000a202020202020000000fc004c4720554c5452414
            74541520a000000ff003130354e544a4a47543735360a013b020350f1230907074c10
            04031f13125d5e5f60613f830100006d030c001000b83c20006001020368d85dc4017
            8800300e30f00066d1a0000020530780004613d613de305c000e2006ae60605016161
            3d336970aad0a0345030203a00204f3100001a6fc200a0a0a05550302035007a84310
            0001a000000000000000000000013'');

          DisplayPort-2 = (builtins.replaceStrings [ "\n" ] [ "" ] ''
            00ffffffffffff0004728f0469e95082191c0103803c22780eee91a3544c99260f505
            421080001010101010101010101010101010101565e00a0a0a0295030203500555021
            00001a000000ff005434544141303038383530320a000000fd00183c1e8c1e010a202
            020202020000000fc00584232373148550a2020202020013302031ac147901f041303
            1201230907018301000065030c0010000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000c1'');
        };
        config = {
          DisplayPort-0= {
            enable = true;
            mode = "2560x1440";
            crtc = 1;
            position = "0x0";
            rate = "59.95";
          };

          DisplayPort-1= {
            enable = true;
            primary = true;
            crtc = 0;
            mode = "3440x1440";
            position = "2560x0";
            rate = "85.00";
          };

          DisplayPort-2= {
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
        Description="autorandr execution hook";
        After="sleep.target";
        StartLimitIntervalSec="5";
        StartLimitBurst="1";
      };
      Service = {
        ExecStart="${pkgs.autorandr} --change --default home";
        Type="oneshot";
        RemainAfterExit="false";
        KillMode="process";
      };
      Install = { WantedBy = "default.target"; };
    };
  };
}
