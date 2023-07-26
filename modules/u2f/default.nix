{
  config.security.pam.u2f = {
    enable = true;
    authFile = ./keys;
    control = "sufficient";
    origin = "pam://foxnet";
  };
}
