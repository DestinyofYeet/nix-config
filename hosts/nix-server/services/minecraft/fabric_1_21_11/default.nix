{ pkgs, ... }:
let
  serverName = "fabric-26_1_2";
in
{
  services.minecraft-servers.servers.${serverName} = {
    enable = true;

    package = pkgs.minecraftServers.${serverName}.override { jre_headless = pkgs.openjdk25_headless; };

    symlinks = {
      mods = pkgs.linkFarmFromDrvs "mods" (
        builtins.attrValues {
          fabric-api = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/tnmuHGZA/fabric-api-0.146.1%2B26.1.2.jar";
            sha256 = "sha256-8Jy/xmxRtw4z4GJ+38wwbXHVn4NGYp4w/mFvW9cmvKg=";
          };
          jei = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/cHJ1j59c/jei-26.1.2-fabric-29.5.0.26.jar";
            sha256 = "sha256-7nF7fXYPIg9the/mxi6pUYEmKtosZO6yL2b0Dgf8+fI=";
          };
        }
      );
    };
  };
}
