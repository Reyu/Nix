{ config, ... }: {
  home.persistence."/persist/home/${config.home.username}" = {
    allowOther = false;
    directories = [
      ".cache/direnv"
      ".cache/keepassxc"
      ".cache/nvim"
      ".config/syncthing"
      ".gnupg"
      ".local/share/nvim"
      ".local/state/nvim"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
    ];
    files = [
      ".config/syncthingtray.ini"
      ".ssh/known_hosts"
    ];
  };
}
