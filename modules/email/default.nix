{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [ pass protonmail-bridge mutt-trim lynx surf ];
  services = {
    imapnotify.enable = true;
  };
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Mail";
    accounts = {
      Proton = {
        address = "reyu@reyuzenfold.com";
        userName = "${config.accounts.email.accounts.Proton.address}";
        realName = "Tim Millican";
        passwordCommand = "pass mail/protonmail";
        primary = true;
        gpg.key = "E5D08B66BC0513C4";
        notmuch.enable = true;
        neomutt = {
          enable = true;
          extraConfig = ''
          '';
        };
        msmtp.enable = true;
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = true;
            useStartTls = true;
            certificatesFile =
              "${config.xdg.configHome}/protonmail/bridge/cert.pem";
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = true;
            useStartTls = true;
            certificatesFile =
              "${config.xdg.configHome}/protonmail/bridge/cert.pem";
          };
        };
        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotify = "${pkgs.isync}/bin/mbsync proton-%s";
          onNotifyPost =
            "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New Mail'";
        };
        mbsync = {
          enable = true;
          groups = {
            proton = {
              channels = {
                INBOX = {
                  farPattern = "INBOX";
                  nearPattern = "";
                };
                Archive = {
                  farPattern = "Archive";
                  nearPattern = "Archive";
                };
                Drafts = {
                  farPattern = "Drafts";
                  nearPattern = "Drafts";
                };
                Sent = {
                  farPattern = "Sent";
                  nearPattern = "Sent";
                };
                Spam = {
                  farPattern = "Spam";
                  nearPattern = "Spam";
                };
                Trash = {
                  farPattern = "Trash";
                  nearPattern = "Trash";
                };
                Folders = {
                  farPattern = "Folders";
                  nearPattern = "Folders";
                  patterns = [ "*" ];
                  extraConfig = { Create = "Both"; };
                };
                Labels = {
                  farPattern = "Labels";
                  nearPattern = "Labels";
                  patterns = [ "*" ];
                  extraConfig = { Create = "Both"; };
                };
              };
            };
          };
        };
      };
      Gmail = {
        address = "tim.millican@gmail.com";
        userName = "${config.accounts.email.accounts.Gmail.address}";
        realName = "Tim Millican";
        passwordCommand = "pass mail/gmail";
        gpg.key = "E5D08B66BC0513C4";
        neomutt.enable = true;
        notmuch.enable = true;
        msmtp.enable = true;
        flavor = "gmail.com";
        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotify = "${pkgs.isync}/bin/mbsync gmail-%s";
          onNotifyPost =
            "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New Mail'";
        };
        mbsync = {
          enable = true;
          groups = {
            gmail = {
              channels = {
                INBOX = {
                  farPattern = "INBOX";
                  nearPattern = "";
                };
                Important = {
                  farPattern = "[Gmail]/Important";
                  nearPattern = "Important";
                };
                Starred = {
                  farPattern = "[Gmail]/Starred";
                  nearPattern = "Starred";
                };
                Junk = {
                  farPattern = "[Gmail]/Junk";
                  nearPattern = "Spam";
                };
                Spam = {
                  farPattern = "[Gmail]/Spam";
                  nearPattern = "Spam";
                };
                Trash = {
                  farPattern = "[Gmail]/Trash";
                  nearPattern = "Trash";
                };
              };
            };
            notifications = {
              channels = {
                Folders = {
                  farPattern = "Notifications";
                  nearPattern = "Notifications";
                  patterns = [ "*" ];
                  extraConfig = { Create = "Both"; };
                };
              };
            };
          };
        };
      };
    };
  };
  programs = {
    afew = {
      enable = true;
      extraConfig = ''
        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]
        [InboxFilter]
      '';
    };
    mbsync.enable = true;
    notmuch.enable = true;
    neomutt = {
      enable = true;
      settings = {
        alias_format = ''"%3n %t %-12 %r"'';
        attach_format =
          ''" %u%D%I %t%4n %T%.40d%> [%.7m/%.10M, %.6e%?C?, %C?, %s] "'';
        index_format = ''
          "%4C %2e/%-2E %Z %H %N [ %-20.20L ] %-40.80s %> %J %{%d%b%y %H:%M %z} | %<M?%5M Msgs &%<l?%5l Lines&%5c Bytes>> "'';
        editor = ''
          "nvim -c 'set colorcolumn=80 textwidth=72 formatprg=par\ w72qe' +10"'';
        confirmappend = "no";
      };
      vimKeys = true;
      sidebar = {
        enable = true;
        shortPath = true;
      };
      binds = [
        # {
        #   map = [ "pager" "index" ];
        #   key = "^O";
        #   action = "sidebar-prev";
        # }
      ];
      macros = [
        {
          map = [ "index" "pager" ];
          key = "S";
          action = "<tag-prefix><save-message>=Archive<enter>";
        }
      ];
      extraConfig = ''
        source ${config.xdg.configHome}/neomutt/color
      '';
    };
  };
  home.file = {
    ".mailcap".source = ../mailcap;
  };
  xdg.configFile = {
    "neomutt/color".source = ../neomutt/colors;
  };
}
