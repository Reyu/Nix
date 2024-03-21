let
  tailscale_domain = "wolf-diatonic.ts.net";
in {
  auth = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLh/19bPHzmaJNswjqqt1aR/DwCdAsWRnjnCHQ/0VJc";
    extraHostNames = [
      "auth.reyuzenfold.com"
    ];
  };
  burrow = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";
    extraHostNames = [
      "burrow.home.reyuzenfold.com"
      "burrow.${tailscale_domain}"
    ];
  };
  cloud = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBMdlD2uBxtZLHfOUQ61JbjyLmoU4yOXSYyWG2KFrTz";
    extraHostNames = [
      "cloud.reyuzenfold.com"
      "cloud.${tailscale_domain}"
    ];
  };
  ct13719 = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTmgMl+17ZpcKkGgSIlZDv/X2iQNHAQ6RWJQ5vCIZTJ";
    extraHostNames = [
      "ct13719.${tailscale_domain}"
    ];
  };
  files = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtONif8fHUnxLakF6D5Solv/Xm2bN1z3d3GUrmOg0vF";
    extraHostNames = [
      "files.reyuzenfold.com"
      "files.${tailscale_domain}"
    ];
  };
  gitlab = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtdO5n/P+ao2kyfDMrVmWUNe40dZpDJYiIRGaLPSzky";
    extraHostNames = [
      "gitlab.reyuzenfold.com"
    ];
  };
  loki = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5RyYh6rTQJrsriGzONG4Dt0cb3Y3047KSFlylzm2zZ";
    extraHostNames = [
      "loki.home.reyuzenfold.com"
      "loki.${tailscale_domain}"
    ];
  };
  mastodon = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtONif8fHUnxLakF6D5Solv/Xm2bN1z3d3GUrmOg0vF";
    extraHostNames = [
      "reyuzenfold.com"
    ];
  };
  openhab = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFR+Ajqmtgj16Nc7Kc4DBldBQXHKGAvR6WDqulQFzpJB";
    extraHostNames = [
      "openhab.home.reyuzenfold.com"
      "openhab.${tailscale_domain}"
    ];
  };
  steamdeck = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnyBQsKM1xbT9+kqPSezrHyxHM7/rzqx89vwaHMliRo";
    extraHostNames = [
      "steamdeck.${tailscale_domain}"
    ];
  };
  traveler = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhbhOKgiYOV65i4DVIHjjeiDI6OSHc/6ci1nIb7j99v";
    extraHostNames = [
      "traveler.${tailscale_domain}"
    ];
  };
}
