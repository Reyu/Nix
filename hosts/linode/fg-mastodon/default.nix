{ config, pkgs, ... }: {
  config = {
    age.secrets = {
      "database.pass" = {
        file = ./secrets/db.pass;
        owner = "mastodon";
      };
      "smtp.pass" = {
        file = ./secrets/smtp.pass;
        owner = "mastodon";
      };
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    users.users.caddy.extraGroups = [ "mastodon" ];
    services = {
      mastodon = {
        enable = true;
        localDomain = "fuzzygames.social";
        database = {
          createLocally = false;
          host = "lin-11473-3085-pgsql-primary.servers.linodedb.net";
          name = "fuzzygames_mastodon";
          user = "fuzzygames_mastodon";
          passwordFile = config.age.secrets."database.pass".path;
        };
        smtp = {
          createLocally = false;
          host = "smtp.protonmail.ch";
          port = 587;
          user = "mastodon@fuzzygames.social";
          fromAddress = "mastodon@fuzzygames.social";
          passwordFile = config.age.secrets."smtp.pass".path;
          authenticate = true;
        };
      };
      caddy = {
        enable = true;
        virtualHosts = {
          "fuzzygames.social" = {
            extraConfig = ''
              handle_path /system/* {
                  file_server * {
                      root /var/lib/mastodon/public-system
                  }
              }
              handle /api/v1/streaming/* {
                  reverse_proxy  unix//run/mastodon-streaming/streaming.socket
              }

              route * {
                  file_server * {
                  root ${pkgs.mastodon}/public
                  pass_thru
                  }
                  reverse_proxy * unix//run/mastodon-web/web.socket
              }

              handle_errors {
                  root * ${pkgs.mastodon}/public
                  rewrite 500.html
                  file_server
              }

              encode gzip

              header /* {
                  Strict-Transport-Security "max-age=31536000;"
              }
              header /emoji/* Cache-Control "public, max-age=31536000, immutable"
              header /packs/* Cache-Control "public, max-age=31536000, immutable"
              header /system/accounts/avatars/* Cache-Control "public, max-age=31536000, immutable"
              header /system/media_attachments/files/* Cache-Control "public, max-age=31536000, immutable"
            '';
          };
        };
      };
    };
  };
}
