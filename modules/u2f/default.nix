{ pkg, lib, ... }:
{
  config.security.pam.u2f = {
    enable = true;
    authFile = ./keys;
    control = "required";
    origin = "pam://foxnet";
  };
}
