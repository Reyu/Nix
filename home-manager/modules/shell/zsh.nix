{ pkgs, inputs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    autocd = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      ENHANCD_FILTER = "fzf-tmux --height 50% --reverse --ansi --preview 'lsd -l --color=always {}'";
      ENHANCD_DOT_SHOW_FULLPATH = "1";
      BAT_THEME = "Solarized (dark)";
      GOPATH = "~/.go";
    };

    # initExtraBeforeCompInit
    initExtra = ''
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
      bindkey '^ ' autosuggest-accept

      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';
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
      ignoreSpace = true;
      save = 15000;
      share = true;
    };

    dirHashes = {
      # Allows addressing directorys by shortname
      docs = "$HOME/Documents";
      projects = "$HOME/Projects";
      nix = "$HOME/Projects/FoxNet/Nix";
    };

    shellAliases = rec {
      # Prevent globbing/autocorrect on some commands
      nix-env = "noglob nix-env";
      mv = "nocorrect mv";
      cp = "nocorrect cp";
      mkdir = "nocorrect mkdir";
      ipfs = "ipfs --api=/ip4/127.0.0.1/tcp/5001";

      # ls replacement
      ls = "${pkgs.lsd}/bin/lsd --group-dirs first";
      ll = "${ls} -lF";
      tree = "${ls} --tree";

      # Git
      gs = "${pkgs.git}/bin/git status";
      gc = "${pkgs.git}/bin/git commit";
      gl = "${pkgs.git}/bin/git log";

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

      # Other
      ISODATE = "$(date --iso-8601=date)";
    };

    plugins = [
      {
        name = "zsh-vimode-visual";
        src = inputs.zsh-vimode-visual;
      }
    ];

  };
}
