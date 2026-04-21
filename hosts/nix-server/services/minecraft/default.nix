{ ... }:
{
  imports = [
    ./modded_1_21_1
    ./fabric_1_21_11
  ];

  services.minecraft-servers = {
    enable = true;
    dataDir = "/mnt/data/data/minecraft";
    eula = true;

    managementSystem = {
      tmux = {
        enable = true;
      };
    };
  };
}
