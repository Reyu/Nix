{
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

      continuation_prompt = "▶▶ ";

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

      direnv.disabled = false;

      kubernetes.disabled = false;

      nix_shell = { symbol = "❄  "; };

      os.disabled = false;

      sudo.disabled = false;

      username = {
        show_always = true;
        style_user = "bold green";
        style_root = "bold red";
      };
    };
  };
}
