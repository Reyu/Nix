{ config, ... }: {
  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = false;
    directories = [
      ".cache/nvim"
      ".gnupg"
      ".local/share/direnv"
      ".local/share/keyrings"
      ".ssh"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Videos"
    ];
    files = [
      ".zsh_history"
    ];
  };
}
