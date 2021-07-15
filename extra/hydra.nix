{ config, pkgs, ... }:

{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    useSubstitutes = true;
  };
  nix.buildMachines = [
    { hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = ["kvm" "nixos-test" ];
      maxJobs = 16;
    }
  ];
}
