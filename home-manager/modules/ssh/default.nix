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
    };
    includes = [
      "local_config"
    ];
    matchBlocks = {
      "!172.16.0.*,*" = {
        "StrictHostKeyChecking" = "yes";
      };
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
