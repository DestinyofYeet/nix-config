{
  flake,
  ...
}:
{
  services.syncthing = {
    enable = true;

    settings = {
      folders = {
        deposit = {
          id = "deposit";
          path = "~/deposit";
          versioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "7776000";
            };
          };

          devices = [
            "nix-server"
            "handy"
          ];
        };
      };

      devices = {
        nix-server = {
          id = "TL3POH2-BE5EXKK-K4HJFLD-WHU2FVQ-7RYUQ76-OIW6L4P-DQHY5DC-EGALKQC";
          name = "nix-server";
          numconnections = 10;
        };

        handy = flake.nixosConfigurations."nix-server".config.services.syncthing.settings.devices.handy;
      };
    };
  };
}
