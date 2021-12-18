{ config, ... }: {
  config = {
    # System-wide environment variables to be set
    environment = {
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
