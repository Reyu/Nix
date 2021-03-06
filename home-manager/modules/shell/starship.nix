{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {

      character = {
        success_symbol = "[๐บ](#c792ea)";
        vicmd_symbol = "[ยป](bold green)";
        error_symbol = "[ร](bold red) ";
      };

      nix_shell = { symbol = "โ  "; };

      git_status = {
        ahead = "โ";
        behind = "โ";
        diverged = "โ";
        modified = "!";
        staged = "ยฑ";
        renamed = "โ";
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
