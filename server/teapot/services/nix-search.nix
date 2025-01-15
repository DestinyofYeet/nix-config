{
  inputs,
  pkgs,
  ...
}:{
  services.nginx.virtualHosts."search.ole.blue" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root = inputs.nuscht-search.packages.${pkgs.stdenv.system}.mkMultiSearch {
      scopes = [
        {
          modules = [ inputs.strichliste.nixosModules.strichliste ]; name = "strichliste"; urlPrefix = "https://git.ole.blue/ole/strichliste.nix/src/branch/docker";
        }
      ];
    };
  };
}
