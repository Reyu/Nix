{ config, lib, pkgs, ... }:

{
  services.consul = {
    enable = true;
    webui = true;
  };
}
