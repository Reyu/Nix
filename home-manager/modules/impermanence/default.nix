{ config, ... }: {
  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = false;
    directories = [
      ".cache/keepassxc"
      ".cache/nvim"
      ".gnupg"
      ".local/share"
      "Documents"
      "Downloads"
      "Projects"
    ];
    files = [
      ".ssh/known_hosts"
      ".zsh_history"
    ];
  };
}
