{
  config.users.ldap = {
    enable = true;
    loginPam = false;
    base = "dc=reyuzenfold,dc=com";
    server = "ldap://ldap.reyuzenfold.com";
    useTLS = true;
    nsswitch = false;
    extraConfig = ''
      SASL_MECH GSSAPI
    '';
  };
}
