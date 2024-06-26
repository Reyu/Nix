{
  services = {
    ssh-agent.enable = true;
  };
  programs.ssh = {
    addKeysToAgent = "confirm";
    controlMaster = "auto";
    controlPersist = "3s";
    enable = true;
    hashKnownHosts = true;
    extraOptionOverrides = {
      "checkHostIP" = "yes";
      "UpdateHostKeys" = "yes";
      "VisualHostKey" = "yes";
      # "StrictHostKeyChecking" = "accept-new";
    };
    includes = [ "local_config" ];
    matchBlocks = {
      "deck" = {
        user = "deck";
      };
      "lish" = {
        hostname = "lish-us-southeast.linode.com";
        extraOptions = {
          "RequestTTY" = "yes";
        };
      };
      "lish-*" = {
        hostname = "%h.linode.com";
        extraOptions = {
          "RequestTTY" = "yes";
        };
      };
    };
  };
}
