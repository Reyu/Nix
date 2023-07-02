{
  consul = {
    modules = [
      ./consul
    ];
  };
  fg-mastodon = {
    modules = [
      ./configuration.nix
      ./fg-mastodon
    ];
  };
}
