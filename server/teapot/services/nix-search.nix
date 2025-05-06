{ inputs, pkgs, lib, ... }:
let
  build-scope = modules: name: prefix: {
    modules = [{ _module.args = { inherit pkgs lib; }; }]
      ++ (lib.lists.toList modules);
    name = name;
    urlPrefix = prefix;
  };
in {
  services.nginx.virtualHosts."options.ole.blue" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root =
      inputs.nuscht-search.packages.${pkgs.stdenv.system}.mkMultiSearch {
        scopes = [
          (build-scope inputs.strichliste.nixosModules.strichliste "strichliste"
            "https://git.ole.blue/ole/strichliste.nix/src/branch/no-docker")
          (build-scope inputs.agenix.nixosModules.default "agenix"
            "https://github.com/ryantm/agenix/tree/main")
          (build-scope inputs.lanzaboote.nixosModules.lanzaboote "lanzaboote"
            "https://github.com/nix-community/lanzaboote/tree/main")
          (build-scope inputs.networkNamespaces.nixosModules.networkNamespaces
            "networkNamespaces"
            "https://github.com/DestinyofYeet/namespaces.nix/tree/main")
          {
            optionsJSON =
              (import "${inputs.nixpkgs}/nixos/release.nix" { }).options
              + /share/doc/nixos/options.json;
            name = "NixOS";
            urlPrefix = "https://github.com/NixOS/nixpkgs/tree/master/";
          }
          # (build-scope inputs.home-manager.nixosModules.home-manager
          #   "HomeManager" "https://example.com")
          (build-scope [
            inputs.simple-nixos-mailserver.nixosModules.default
            {
              mailserver = {
                fqdn = "mx.example.com";
                domains = [ "example.com" ];
                dmarcReporting = {
                  organizationName = "Example Corp";
                  domain = "example.com";
                };
              };
            }
          ] "simple-nixos-mailserver"
            "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/master/")
          # (build-scope inputs.auto-add-torrents.nixosModules.default "auto-add-torrents" "https://git.ole.blue/ole/auto-add-torrents-python/src/branch/main")
          (build-scope inputs.microvm-nix.nixosModules.host "microvm.nix host"
            "https://github.com/astro/microvm.nix/tree/master")
          (build-scope inputs.microvm-nix.nixosModules.microvm
            "microvm.nix guest"
            "https://github.com/astro/microvm.nix/tree/master")

          (build-scope inputs.nix-minecraft.nixosModules.minecraft-servers
            "nix-minecraft"
            "https://github.com/Infinidoge/nix-minecraft/tree/master")

          (build-scope inputs.hardware.nixosModules.raspberry-pi-4 "HW: RP 4"
            "https://github.com/NixOS/nixos-hardware/tree/master")
        ];
      };
  };
}
