{ configs, pkgs, libs, ... }: {
  home.packages = with pkgs; [ xclip ];
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "viins";
    cdpath = [ "~/Projects" ];
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
    localVariables = {
      ENHANCD_FILTER =
        "fzf-tmux --height 50% --reverse --ansi --preview 'lsd -l --color=always {}'";
      ENHANCD_DOT_SHOW_FULLPATH = "1";
    };
    initExtra = ''
      [[ -s ~/.nix-profile/etc/profile.d/nix.sh ]] && source ~/.nix-profile/etc/profile.d/nix.sh

      autoload -Uz edit-command-line
      zle -N edit-command-line

      # On empty line, run `bg` else hold command {{{
      fancy-ctrl-z () {
          if [[ $#BUFFER -eq 0 ]]; then
              bg
              zle redisplay
          else
              zle push-input
          fi
      }
      zle -N fancy-ctrl-z # }}}

    '';
    loginExtra = ''
      neofetch

      ${pkgs.keychain}/bin/keychain --quiet --agents gpg,ssh --systemd
      source ~/.keychain/$(hostname -s)-sh
      source ~/.keychain/$(hostname -s)-sh-gpg

      # Link the socket at a known location
      ln -s $SSH_AUTH_SOCK ~/.keychain/$(hostname -s)-ssh.sock

    '';
    shellAliases = {
      nix-env = "noglob nix-env";
      mv = "nocorrect mv";
      cp = "nocorrect cp";
      mkdir = "nocorrect mkdir";
      tree = "lsd --tree";
    };
    shellGlobalAliases = {
      ISODATE = "$(date --iso-8601=date)";
      PL = "| \${PAGER}";
      PG = "| grep -P";
      PE = "| egrep";
      PN1 = "> /dev/null";
      PN2 = "2> /dev/null";
      PN = "&> /dev/null";
      CLIP = "$(xclip -o -sel clip)";
      CSEL = "$(xclip -o -sel primary)";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "Tarrasch/zsh-functional"; }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [ "defer:2" ];
        }
        { name = "zsh-users/zsh-history-substring-search"; }
        {
          name = "b4b4r07/zsh-vimode-visual";
          tags = [ "use:'*.zsh'" "defer:3" ];
        }
        { name = "zsh-users/zsh-completions"; }
        { name = "greymd/tmux-xpanes"; }
        {
          name = "k4rthik/git-cal";
          tags = [ "as:command" ];
        }
        { name = "rimraf/k"; }
        { name = "Valodim/zsh-curl-completion"; }
        {
          name = "plugins/mosh";
          tags = [ "from:'oh-my-zsh'" ];
        }
        {
          name = "zsh-users/zaw";
          tags = [ "as:plugin" "use:'zaw.zsh'" ];
        }
      ];
    };
  };
}
