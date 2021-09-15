{ pkgs, ... }: {
  config.home.packages = [
    pkgs.vscode
    # (pkgs.vscode-with-extensions.override
    # {
    #   vscodeExtensions = with pkgs.vscode-extensions; [
    #     editorconfig.editorconfig
    #     haskell.haskell
    #     ms-python.python
    #     ms-vscode-remote.remote-ssh
    #     vscodevim.vim
    #     zhuangtongfa.material-theme
    #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #     {
    #       name = "Nix";
    #       publisher =  "bbenoist";
    #       version = "1.0.1";
    #       sha256 = "qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
    #     }
    #     {
    #       name = "nix-env-selector";
    #       publisher = "arrterian";
    #       version = "1.0.7";
    #       sha256 = "DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
    #     }
    #   ];
    # })
  ];
}