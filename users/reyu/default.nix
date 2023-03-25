{ self, config, pkgs, inputs, ... }: {

  users.users.reyu = {
    isNormalUser = true;
    home = "/home/reyu";
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "audio" "adbusers" "dialout" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8 reyu@kp"  # Decom
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHvQ7trBr3VvRDSmWBRCgi+KfW8/lvHSTgbaFgCmstnSAAAABHNzaDo= reyu@onlykey"
    ];
    initialHashedPassword = "$6$BgizkUy7nfY0Cz/n$oMnCCYyr2jATMmzkGWrxUd8R4.9DNTHEB5T3MWTZzuzPMrQ9WrzMSrM2u6j3EJ0ddE7PSo6t8F1n8TYdj/tCe1";
  };
  home-manager.users.reyu = import ../../home-manager/profiles/common.nix;

  # Allow to run nix
  nix.settings.allowed-users = [ "reyu" ];
  # Trust user to allow importing closures and configuring binary caches
  nix.settings.trusted-users = [ "reyu" ];
}
