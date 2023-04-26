{ config, lib, pkgs, ... }:
{
  config = {
    networking.wireless.enable = false;
    networking.networkmanager.enable = true;

    environment.etc."machine-info".text = ''
      CHASSIS="handset"
    '';

    programs.calls.enable = true;
    hardware.sensor.iio.enable = true;
    hardware.firmware = [ config.mobile.device.firmware ];

    services.xserver = {
      enable = true;
      desktopManager = {
        phosh = {
          enable = true;
          user = "reyu";
          group = "users";
        };
        plasma5.mobile = {
          enable = true;
          installRecommendedSoftware = false;
        };
      };
      displayManager = {
        defaultSession = "plasma-mobile";
        sddm.enable = true;
      };
      videoDrivers = lib.mkDefault [ "modesetting" "fbdev" ];
    };

    powerManagement.enable = true;
    services.upower.enable = true;
    hardware.opengl.enable = true;

    users.users.reyu.hashedPassword = "$6$ilnpyf7xHLALBXwD$9oqaFEu13cxLjpij9ETEjGmQi4/yN/8EsXBFir8ZiLDfPtdkN7pobHk0B5dWazs2pdj6DFUZApnzGFDWL7CW..";

    programs.mosh.enable = true;
  };
}
