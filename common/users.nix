{ config, pkgs, ... }:
{
  users.users.reyu = {
    isNormalUser = true;
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    uid = 1000;
    subGidRanges = [
       { count = 1;   startGid = 100;  }
       { count = 999; startGid = 1001; }
    ];
    subUidRanges = [
       { count = 1;     startUid = 1000;   }
       { count = 65534; startUid = 100001; }
    ];
  };
}
