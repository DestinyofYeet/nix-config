{ ... }: {
  imports = [ ./modded_1_21_1 ];
  services.minecraft-servers = {
    enable = true;
    dataDir = "/mnt/data/data/minecraft";
    eula = true;

    managementSystem = { tmux = { enable = true; }; };
  };
}
