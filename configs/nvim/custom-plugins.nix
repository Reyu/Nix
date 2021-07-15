{ pkgs, ... }:

{
  vim-solarized8 = pkgs.vimUtils.buildVimPlugin {
    name = "vim-solarized8";
    src = pkgs.fetchFromGitHub {
      owner = "lifepillar";
      repo = "vim-solarized8";
      rev = "28b81a4263054f9584a98f94cca3e42815d44725";
      sha256 = "usnDuV0EJ7jD0eB+/NLIhLRle865hbbuF7MC33R3AG8=";
      fetchSubmodules = true;
    };
  };
  telescope-hoogle = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-hoogle";
    src = pkgs.fetchFromGitHub {
      owner = "luc-tielen";
      repo = "telescope_hoogle";
      rev = "01d3b174754cb335a7f06ce602f1690e34bb63de";
      sha256 = "uMriQ9NeeYySrbRuOdycJOdL0PV+mp8MSYGB3TMHOsQ=";
      fetchSubmodules = true;
    };
  };
}
