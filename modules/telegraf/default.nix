{ config, ... }: {
  config.services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        cpu = { };
        disk = { };
        diskio = { };
        docker = { };
        mem = { };
        net = { };
        swap = { };
        system = { };
        zfs = { };
        processes = { };
        influxdb = { };
        systemd_units = { };
      };
      outputs = {
        influxdb = {
          database = "telegraf";
          urls = [ "http://localhost:8086" ];
        };
      };
    };
  };
}
