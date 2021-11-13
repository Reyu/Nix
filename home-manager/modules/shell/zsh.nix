{ config, pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";

    sessionVariables = {
      ZDOTDIR = "/home/reyu/.config/zsh";
      EDITOR = "nvim";
      VISUAL = "nvim";
      ENHANCD_FILTER = "fzf-tmux --height 50% --reverse --ansi --preview 'lsd -l --color=always {}'";
      ENHANCD_DOT_SHOW_FULLPATH = "1";
    };

    initExtraBeforeCompInit = builtins.readFile ./zshrc;
    #initExtra = builtins.readFile ./zshrc-extra;
    loginExtra = ''
      ${pkgs.neofetch}/bin/neofetch
      ${pkgs.keychain}/bin/keychain --quiet --agents gpg,ssh --systemd
      source ~/.keychain/$(hostname -s)-sh
      source ~/.keychain/$(hostname -s)-sh-gpg

      # Link the socket at a known location for KeePass
      ln -fs $SSH_AUTH_SOCK ~/.keychain/$(hostname -s)-ssh.sock
    '';

    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = false;
      save = 15000;
      share = true;
    };

    dirHashes = {
      # Allows addressing directorys by shortname
      docs = "$HOME/Documents";
      projects = "$HOME/Projects";
    };

    shellAliases = rec {

      # Prevent globbing/autocorrect on some commands
      nix-env = "noglob nix-env";
      mv = "nocorrect mv";
      cp = "nocorrect cp";
      mkdir = "nocorrect mkdir";

      # Exa ls replacement
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
      l = "${ls} -lbF --git --icons";
      ll = "${l} -G";
      la =
        "${ls} -lbhHigmuSa@ --time-style=long-iso --git --color-scale --icons";
      lt = "${ls} --tree --level=2 --icons";

      # Git
      gs = "${pkgs.git}/bin/git status";

      # Other
      lsblk = "lsblk -o name,mountpoint,label,size,type,uuid";
      c = "${pkgs.bat}/bin/bat -n --decorations never";
      qr_gen = "${pkgs.qrencode}/bin/qrencode -t ansi -o-";
      top = "${pkgs.htop}/bin/htop";
      zzz = "systemctl suspend";

      serve =
        "nix-shell -p python38Packages.httpcore --run 'python -m http.server 8080'";
    };

    shellGlobalAliases = {
      # Pipe shortcuts
      PL = "| \${PAGER}";
      PG = "| grep -P";
      PE = "| egrep";
      PN1 = "> /dev/null";
      PN2 = "2> /dev/null";
      PN = "&> /dev/null";

      # Clipboard access
      CLIP = "xclip -sel clip";
      CSEL = "xclip -sel primary";

      # Other
      ISODATE = "$(date --iso-8601=date)";
    };

    zplug = {
      enable = true;
      plugins = [
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
