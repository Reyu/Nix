{
  programs = {
    git = {
      enable = true;

      userName = "reyu";
      userEmail = "reyu@reyuzenfold.com";

      signing = {
        key = "0x8DA67C907DD6F454";
        signByDefault = true;
      };

      aliases = {
        last = "cat-file commit HEAD";
      };

      ignores = [
        ### Nix
        # Ignore build outputs from performing a nix-build or `nix build` command
        "result"
        "result-*"
        ### GPG
        "secring.*"
        ### Linux
        "*~"
        # temporary files which can be created if a process still has a handle open of a deleted file
        ".fuse_hidden*"
        # KDE directory preferences
        ".directory"
        # Linux trash folder which might appear on any partition or disk
        ".Trash-*"
        # .nfs files are created when an open file is removed but is still being accessed
        ".nfs*"
        ### Vim
        # Mind map
        ".mind"
        # Swap
        "[._]*.s[a-v][a-z]"
        "[._]*.sw[a-p]"
        "[._]s[a-rt-v][a-z]"
        "[._]ss[a-gi-z]"
        "[._]sw[a-p]"
        # Session
        "Session.vim"
        "Sessionx.vim"
        # Temporary
        ".netrwhist"
        "*~"
        # Auto-generated tag files
        "tags"
        # Persistent undo
        "[._]*.un~"
        ### Darcs VCS
        "_darcs"
        ### Ansible
        "*.retry"
        ### Shell / Other
        ".env"
        ".env.local"
        ".direnv"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        url."git@github.com:".insteadOf = "github:";
        url."reyu@gitlab.reyuzenfold.com:".insteadOf = "lab:";
        safe.directory = [
          "/etc/nixos"
        ];
      };
    };
  };
}
