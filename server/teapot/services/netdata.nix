{ custom, pkgs, lib, ... }: {

  nixpkgs.config.allowUnfree = true;

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloudUi = true; };
  };

  services.nginx.virtualHosts."netdata.ole.blue" = {
    enableACME = true;
    forceSSL = true;
    locations = {

      "/" = {
        proxyPass = "http://localhost:19999";
        extraConfig = custom.snippets.nginx.authelia.root;
      };
    } // custom.snippets.nginx.authelia.location;
  };
}
