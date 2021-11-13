{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {

      character = {
        success_symbol = "[𝝺](#c792ea)";
        vicmd_symbol = "[»](bold green)";
        error_symbol = "[×](bold red) ";
      };

      nix_shell = { symbol = "❄  "; };

      git_status = {
        ahead = "↑";
        behind = "↓";
        diverged = "↕";
        modified = "!";
        staged = "±";
        renamed = "→";
      };

      directory = {
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 2;

        substitutions = {
          "~/Projects/FoxNet/NixOS" = "<reyu/nixos>";
        };
      };
    };
  };
}
