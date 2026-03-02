{
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

        handy = {
          name = "Handy";
          id = "SLOYG5Q-RMVBV5F-E5MO32D-DYCKEV5-A7K74AX-EKGAEJW-HPDIHER-4FJK6AR";
          numconnections = 10;
        };
      };
    };
  };
}
