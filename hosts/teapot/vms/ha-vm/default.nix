{ ... }:
{
  imports = [
    ./configuration.nix
    ../../../parts/vaultwarden/config.nix
    ../../../parts/idp/config.nix
  ];
}
