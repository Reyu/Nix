{ pkgs, ... }: {
  config = {
    home.packages = with pkgs; [ neomutt notmuch ];
    programs = {
      neomutt = {
        enable = true;
        sidebar.enable = true;
        sidebar.format = "%B%?F? [%F]?%* %?N?%N/?%S";
        vimKeys = true;
        settings = {
          delete = "no";
          delete_untag = "yes";
          edit_headers = "yes";
          editor = ''
            "nvim -c 'set colorcolumn=80 textwidth=72 formatprg=par\ w72qe' +10"'';
          implicit_auto_view = "yes";
          index_format = ''
            "%4C %2e/%-2E %Z %H %N [ %-35.40F ] %s %> %{%d%b%y %H:%M %z} | %<M?%5M Msgs &%<l?%5l Lines&%5c Bytes>> "'';
          ispell = ''
            "${pkgs.aspell}/bin/aspell --language-tag=en --lang=en --mode=email check"'';
          move = "no";
          user_agent = "no";
        };
        macros = [
          {
            action = ":push <sidebar-prev><enter>";
            map = [ "index" ];
            key = "\\cP";
          }
          {
            action = ":push <sidebar-next><enter>";
            map = [ "index" ];
            key = "\\cN";
          }
          {
            action = ":push <sidebar-open><enter>";
            map = [ "index" ];
            key = "\\cO";
          }
        ];
        extraConfig = ''
          alternative_order text/plain text/enriched text/html;

          ignore *
          unignore From:
          unignore To
          unignore Date
          unignore Subject
          unignore Cc
          unignore X-Mailer
          unignore User-Agent
          unignore Organization
          unignore X-GPG-Public-Key
          unignore Newsgroup
          unignore Precedence
          unignore Mailing-list

          unmy_hdr *
          set hdrs
          my_hdr X-Editor: `nvim --version | head -n 1`
          my_hdr User-Agent: `neomutt -v | head -n 1 ` (`uname -a | tr -s ' ' ' ' | cut -d ' ' -f1,3 | tr ' ' ' '`)
        '';
      };
      notmuch = {
        enable = true;
        new.tags = [ "unread" ];
        hooks.postNew = "";
      };
      mbsync = { enable = true; };
      khal = { enable = false; }; # BROKEN
    };

    home.file.".config/mailcap" = {
      text = ''
        text/html; ${pkgs.lynx}/bin/lynx '%s'
        text/html; ${pkgs.lynx}/bin/lynx -dump '%s'; copiousoutput
        image/*; ${pkgs.kitty}/bin/kitty +kitten icat '%s'; copiousoutput
      '';
      # application/ics; ${importcal-bin} '%s'; test=test -n "$DISPLAY"
      # text/calendar; ${importcal-bin} '%s'; test=test -n "$DISPLAY"
    };

    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = [ "network.targt" ];
      };
      Service = {
        Type = "simple";
        Restart = "always";
        ExecStart =
          "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
