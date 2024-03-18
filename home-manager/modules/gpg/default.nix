{ pkgs, lib, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = lib.mkDefault pkgs.pinentry-qt;
}
