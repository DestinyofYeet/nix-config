{ pkgs, lib, config, ... }:
let
  mods = pkgs.stdenv.mkDerivation {
    name = "mods";
    src = pkgs.fetchurl {
      url =
        "https://cloud.ole.blue/public.php/dav/files/RaxCELdG4bTJoj2/?accept=zip";
      hash = "sha256-FH/ghVA1FR3VhLTvUYoMpukfD3njGP7ztw4VXcw+TU4=";
    };

    unpackPhase = ''
      ${lib.getExe' pkgs.unzip "unzip"} -j $src
    '';

    installPhase = ''
      mkdir -p $out
      cp * $out
    '';

  };

  connect = pkgs.writeShellScript "connect.sh" ''
    ${
      lib.getExe' pkgs.tmux "tmux"
    } -S ${config.services.minecraft-servers.runDir}/modded_1_21_1.sock attach
  '';

  server = pkgs.fetchurl {
    url =
      "https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.216/neoforge-21.1.216-installer.jar";
    hash = "sha256-sP2RxDmdoAkvAi3rP6T1kcT+aqiLd87+x2nBy4jkFxQ=";
  };

  java = (lib.getExe' pkgs.jdk "java");

in {
  services.minecraft-servers.servers."modded_1_21_1" = {
    enable = false;

    package = (pkgs.writeShellScriptBin "start-server" ''
      if [ ! -d "libraries" ]; then
        ${java} -jar ${server} --install-server --server-jar
      fi

      ${java} -jar server.jar nogui
    '');

    files = { "mods" = mods; };
    symlinks = { "connect.sh" = connect; };
  };
}
