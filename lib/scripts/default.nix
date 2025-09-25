{ inputs, pkgs, lib, ... }:
let
  sendError = message:
    ''notify-send -u critical -c error -t 5000 "${message}"'';
  sendMessage = message: ''notify-send -t 5000 "${message}"'';
in {
  generate-email-alias = pkgs.writers.writePython3Bin "generate-email-alias" {
    flakeIgnore = [ "W291" "E305" "E501" "E111" "E302" ];
  } ./create-email-alias.py;

  startOpenfortiVpn = configPath:
    pkgs.writers.writeBash "startOpenfortiVpn" ''
      ${pkgs.zenity}/bin/zenity --password --title="Enter sudo password for vpn" | sudo -Sv || { ${
        sendError "Wrong sudo password"
      }; exit; }

      sudo ${pkgs.openfortivpn}/bin/openfortivpn -c ${configPath} &

      pid=$!

      sudo kill -0 $pid || { ${sendError "Failed to start vpn"}; exit; }

      ${sendMessage "Started vpn"}
    '';

  stopOpenfortiVpn = pkgs.writers.writeBash "stopOpenfortiVpn" ''
      ${pkgs.zenity}/bin/zenity --password --title="Enter sudo password for vpn" | sudo -Sv || { ${
        sendError "Wrong sudo password"
      }; exit; }        

    sudo kill openfortivpn || { ${sendError "Failed to kill vpn"}; exit; }

    ${sendMessage "Stopped vpn"}
  '';
}
