{ self, config, ... }:

{
  age.secrets.acme_hetzner = {
    file = "${self}/secrets/acme/hetzner_apikey";
    mode = "600";
    name = "hetzner_api_key";
    owner = "acme";
  };

  security.acme.acceptTerms = true;
  security.acme.defaults = {
    environmentFile = config.age.secrets.acme_hetzner.path;
    dnsProvider = "hetzner";
    email = "acme@reyu.slmail.me";
  };

}
