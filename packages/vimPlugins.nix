{ pkgs, ... }: {
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
  nvim-cmp = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-cmp";
    dontBuild = true;
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "ada9ddeff71e82ad0e52c9a280a1e315a8810b9a";
      sha256 = "xvMSMQa100a1gE0lBmab9E5ybK6lvoD76igQj3tv8KU=";
      fetchSubmodules = true;
    };
  };
  cmp-nvim-lsp = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-nvim-lsp";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "f93a6cf9761b096ff2c28a4f0defe941a6ffffb5";
      sha256 = "vfL4OXpufc3lN3SGJsV1T4xOa5wyn05GdYRSms6VpAs=";
      fetchSubmodules = true;
    };
  };
  cmp-buffer = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-buffer";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-buffer";
      rev = "5dde5430757696be4169ad409210cf5088554ed6";
      sha256 = "lLP6gnuSN/tJiJ1sb2u6Xm5G2P59pz6tnOGDRfbivjk=";
      fetchSubmodules = true;
    };
  };
  cmp-nvim-ultisnips = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-nvim-ultisnips";
    src = pkgs.fetchFromGitHub {
      owner = "quangnguyen30192";
      repo = "cmp-nvim-ultisnips";
      rev = "1cb6d73d120026640edc54d4f0379f10f8677626";
      sha256 = "h+5+CnEO5hOrbHqVn8ukULqBh8H5QE1U/JqQH+EzSHs=";
      fetchSubmodules = true;
    };
  };
}
