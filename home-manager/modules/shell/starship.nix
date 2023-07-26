{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      username = {
        show_always = true;
        style_user = "bold green";
        style_root = "bold red";
      };

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
        truncation_length = 4;
        truncation_symbol = ".../";
        truncate_to_repo = true;
        repo_root_style = "yellow";
        fish_style_pwd_dir_length = 2;

        substitutions = {
          "~/Projects/FoxNet/Nix" = "<Reyu/NixOS>";
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      cmd_duration = {
        show_notifications = true;
      };

      sudo.disabled = false;
      status.disabled = false;
    };
  };
}
