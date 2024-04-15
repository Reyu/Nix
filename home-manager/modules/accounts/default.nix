{ pkgs, config, ... }:
{
  config = {
    accounts = {
      contact.basePath = "Contacts";
      contact.accounts = {
        nextcloud = {
          khard.enable = true;
          local = {
            type = "filesystem";
            fileExt = ".vcf";
          };
          remote = {
            type = "carddav";
            url = "https://cloud.reyuzenfold.com/remote.php/dav/addressbooks/users/reyu/contacts/";
            userName = "reyu";
            passwordCommand = [
              "${pkgs.libsecret}/bin/secret-tool"
              "lookup"
              "service"
              "nextcloud"
            ];
          };
          vdirsyncer = {
            enable = true;
            conflictResolution = "remote wins";
          };
        };
      };
      calendar.basePath = "Calendars";
      calendar.accounts = {
        nextcloud = {
          khal = {
            enable = true;
            type = "discover";
          };
          local = {
            type = "filesystem";
            fileExt = ".ics";
          };
          remote = {
            type = "caldav";
            url = "https://cloud.reyuzenfold.com/remote.php/dav/";
            userName = "reyu";
            passwordCommand = [
              "${pkgs.libsecret}/bin/secret-tool"
              "lookup"
              "service"
              "nextcloud"
            ];
          };
          vdirsyncer = {
            enable = true;
            collections = [
              "personal"
              "contact_birthdays"
            ];
            conflictResolution = "remote wins";
          };
        };
      };
      email.accounts = {
        protonmail = {
          primary = true;
          address = "reyu@reyuzenfold.com";
          userName = "reyu@reyuzenfold.com";
          passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup account protonmail";

          realName = "Reyu Zenfold";
          mbsync = {
            enable = true;
            expunge = "both";
            create = "both";
            groups = {
              core.channels = {
                drafts = {
                  farPattern = "Drafts";
                  nearPattern = "Drafts";
                };
                inbox = {
                  farPattern = "INBOX";
                  nearPattern = "Inbox";
                };
                sent = {
                  farPattern = "Sent";
                  nearPattern = "Sent";
                };
                starred = {
                  farPattern = "Starred";
                  nearPattern = "Starred";
                };
              };
              # bulk.channels = {
              #   all-mail = {
              #     farPattern = "All Mail";
              #     nearPattern = "All Mail";
              #   };
              #   archive = {
              #     farPattern = "Archive";
              #     nearPattern = "Archive";
              #   };
              # };
              # sorting.channels = {
              #   folders = {
              #     farPattern = "Folders/";
              #     nearPattern = "f_";
              #     patterns = [ "*" ];
              #   };
              #   labels = {
              #     farPattern = "Labels/";
              #     nearPattern = "l_";
              #     patterns = [ "*" ];
              #   };
              # };
              extra.channels = {
                spam = {
                  farPattern = "Spam";
                  nearPattern = "Spam";
                };
                trash = {
                  farPattern = "Trash";
                  nearPattern = "Trash";
                };
              };
            };
          };
          neomutt = {
            enable = true;
          };
          notmuch = {
            enable = true;
          };

          imap = {
            host = "127.0.0.1";
            port = 1143;
            tls.useStartTls = true;
            tls.certificatesFile = "${config.xdg.configHome}/protonmail/cert.pem";
          };
          smtp = {
            host = "127.0.0.1";
            port = 1025;
            tls.useStartTls = true;
            tls.certificatesFile = "${config.xdg.configHome}/protonmail/cert.pem";
          };
          msmtp.enable = true;
          imapnotify = {
            enable = true;
            boxes = [ "Inbox" ];
            onNotify = "${pkgs.isync}/bin/mbsync %s";
            onNotifyPost = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived in %s'";
          };
        };
      };
    };
  };
}
