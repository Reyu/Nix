{ config, pkgs, lib, ... }: {
  options.foxnet.krb = {
    kdc.enabled = lib.mkEnableOption "Add KDC configuration to krb5.conf";
    kadmind.enabled = lib.mkEnableOption "Run the kadmind daemon";
    ports = {
      openFirewall = lib.mkEnableOption "Open ports in firewall for KDC";
      kdc = lib.mkOption rec {
        type = lib.types.int;
        default = 88;
        example = default;
        description = "Key Distribution Center Port";
      };
      kadmind = lib.mkOption rec {
        type = lib.types.int;
        default = 749;
        example = default;
        description = "Kerberos Administration Server Port";
      };
    };
  };
  config = let cfg = config.foxnet.krb;
  in {
    krb5 = {
      enable = true;
      kerberos = pkgs.heimdal;
      libdefaults = { "default_realm" = "REYUZENFOLD.COM"; };
      realms = {
        "REYUZENFOLD.COM" = {
          admin_server = "ismene.home.reyuzenfold.com";
          kdc = [ "ismene.home.reyuzenfold.com" ];
        };
      };
      domain_realm = {
        "reyuzenfold.com" = "REYUZENFOLD.COM";
        ".reyuzenfold.com" = "REYUZENFOLD.COM";
      };
      extraConfig = lib.mkIf cfg.kdc.enabled ''
        [kdc]
        database = {
          mkey_file = /var/heimdal/m-key
          acl_file = /var/heimdal/kadm5.acl
        }
      '';
    };
    systemd.services = {
      kdc = lib.mkIf cfg.kdc.enabled {
        description = "Key Distribution Center daemon";
        path = [ pkgs.heimdal ];
        script = "${pkgs.heimdal}/libexec/heimdal/kdc";
        wantedBy = [ "multi-user.target" ];
      };
      kadmind = lib.mkIf cfg.kadmind.enabled {
        description = "Remote Administration daemon";
        path = [ pkgs.heimdal ];
        script = "${pkgs.heimdal}/libexec/heimdal/kadmind";
        wantedBy = [ "multi-user.target" ];
      };
    };
    # networking.firewall = lib.mkIf cfg.ports.openFirewall {
    #   allowTCPPorts = lib.mkMerge [
    #     (lib.mkIf cfg.kdc.enabled cfg.ports.kdc)
    #     (lib.mkIf cfg.kadmind.enabled cfg.ports.kadmind)
    #   ];
    # };
  };
}
