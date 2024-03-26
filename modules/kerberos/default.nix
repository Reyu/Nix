{
  config.security.krb5 = {
    enable = true;
    settings = {
      domain_realm = {
        "reyuzenfold.com" = "REYUZENFOLD.COM";
      };
      libdefaults = {
        default_realm = "REYUZENFOLD.COM";
      };
      logging = {
        admin_server = "SYSLOG:NOTICE";
        default = "SYSLOG:NOTICE";
        kdc = "SYSLOG:NOTICE";
      };
      realms = {
        "REYUZENFOLD.COM" = {
          admin_server = "kerberos.reyuzenfold.com";
          kdc = [ "kerberos.reyuzenfold.com" ];
        };
      };
    };
  };
}
