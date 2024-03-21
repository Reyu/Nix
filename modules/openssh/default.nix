{
  config.services.openssh = {
    enable = true;
    startWhenNeeded = true;
    knownHosts = import ./knownHosts.nix;
  };
}
