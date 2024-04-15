{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    autocd = true;
    dotDir = ".config/zsh";
    defaultKeymap = "viins";

    sessionVariables = {
      BAT_THEME = "Solarized (dark)";
      EDITOR = "nvim";
      ENHANCD_DOT_SHOW_FULLPATH = "1";
      ENHANCD_FILTER = "fzf-tmux --height 50% --reverse --ansi --preview 'lsd -l --color=always {}'";
      GOPATH = "~/.go";
      VISUAL = "nvim";
    };

    # initExtraBeforeCompInit
    initExtra = ''
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
      bindkey '^ ' autosuggest-accept

      # Load local config, if it exists
      [[ -f ~/.zshrc ]] && source ~/.zshrc
    '';
    loginExtra = ''
      ${pkgs.neofetch}/bin/neofetch
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
      cp = "nocorrect cp";
      mkdir = "nocorrect mkdir";
      mv = "nocorrect mv";

      # ls replacement
      ls = "${pkgs.lsd}/bin/lsd --group-dirs first";
      ll = "${ls} -lF";
      tree = "${ls} --tree";

      # Other
      c = "${pkgs.bat}/bin/bat -n --decorations never";
      ipfs = "ipfs --api=/ip4/127.0.0.1/tcp/5001";
      lsblk = "lsblk -o name,mountpoint,label,size,type,uuid";
      qr_gen = "${pkgs.qrencode}/bin/qrencode -t ansi -o-";
      top = "${pkgs.htop}/bin/htop";
      zzz = "systemctl suspend";

      serve = "nix-shell -p python38Packages.httpcore --run 'python -m http.server 8080'";
    };

    shellGlobalAliases = {
      # Pipe shortcuts
      PL = "| \${PAGER}";
      PG = "| grep -P";
      PE = "| egrep";
      PN1 = "> /dev/null";
      PN2 = "2> /dev/null";
      PN = "&> /dev/null";

      # Clipboard
      CLIP = lib.mkIf config.wayland.windowManager.sway.enable "$(wl-paste)";

      # Other
      ISODATE = "$(date --iso-8601=date)";
    };

    plugins = [
      {
        name = "zsh-vimode-visual";
        src = inputs.zsh-vimode-visual;
      }
      {
        name = "zsh-navigation-tools";
        src = pkgs.zsh-navigation-tools;
      }
    ];
  };
}
