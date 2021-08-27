{ config, pkgs, lib, ... }:

{
  fonts.fonts = with pkgs; [ nerdfonts powerline-fonts terminus-nerdfont ];

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    keyMode = "vi";
  };
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.unclutter.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "dvorak";
    libinput.enable = true;
    windowManager.xmonad.enable = true;
  };
}
