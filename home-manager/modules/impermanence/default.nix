{ config, ... }: {
  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = true;
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
      "Videos"
    ];
    files = [
      ".zsh_history"
    ];
  };
}
