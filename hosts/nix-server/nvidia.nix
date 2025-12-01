{ config, ... }: {
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaPersistenced = builtins.trace
      "Nvidia persistenced is turned off, because the build was broken. Is it fixed yet?"
      false;
  };
}
