{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUi = true; };
  };
}
