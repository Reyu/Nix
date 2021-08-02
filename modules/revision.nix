{ self, config, lib, ... }: {
  config = {
    # Let 'nixos-version --json' know the Git revision of this flake.
    system.configurationRevision = lib.mkIf (self ? rev) self.rev;
  };
}
