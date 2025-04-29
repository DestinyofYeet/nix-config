{ pkgs, ... }: {

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUi = true; };
  };
}
