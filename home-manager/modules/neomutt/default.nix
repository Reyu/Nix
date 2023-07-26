{
  programs = {
    neomutt = {
      enable = true;
      binds = [
      ];
      macros = [
        {
          action = "!notmuch new";
          key = "\\er";
          map = "index";
        }
      ];
      sidebar.enable = true;
      sidebar.format = "%B%?F? [%F]?%* %?N?%N/?%S";
      vimKeys = true;
      settings = {
        delete = "no";
        delete_untag = "yes";
        edit_headers = "yes";
        editor = "nvim -c 'set colorcolumn=80 textwidth=72 formatprg=par\\ w72qe' +10";
        index_format = "%4C %2e/%-2E %Z %H %N [ %-35.40F ] %s %> %{%d%b%y %H:%M %z} | %<M?%5M Msgs &%<l?%5l Lines&%5c Bytes>> ";
        ispell = "aspell --language-tag=en --lang=en --mode=email check";
        move = "no";
        user_agent = "no";
      };
      extraConfig = ''
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
  };
}
