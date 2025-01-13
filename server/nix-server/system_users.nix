{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  users.users.root.openssh.authorizedKeys.keys = [
  ] ++ config.users.users.ole.openssh.authorizedKeys.keys;

  users.users.ole = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    home = "/home/ole";
    description = "me";
    extraGroups = [
      "wheel"
      "docker"
      "apps"
    ];
    hashedPassword = "$6$s5ZWf9efO2lEySC0$ztuOgJsHnckwmcP5EEpgcDJeUpJD3ZJuynRIuuC.IEBLMBtkZS5R1JQ7c4a/oUU6Tp8eDWNUoHjckyL/hivvg1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQWyDZw1M7t47nJ0vu7EvAd6wfN0yrdDBnT7RaWILN5 ole@wattson"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhLrbWc/gopTJ2ZZW4ZfCzGhjhV9fKb1wdvFLQpmP3y ole@main"
    ];
    packages = with pkgs; [ neovim ];
  };

  # the following uids are mapped to accounts on the host
  users.users.apps = {
    isSystemUser = true;
    uid = 568;
    group = "apps";

    createHome = true;
    home = "/var/homes/apps";
  };

  users.groups.apps = {
    gid = 568;
  };

  users.users.monero = {
    isSystemUser = true;
    uid = 992;
    group = "monero";
    extraGroups = [ "apps" ];
  };

  users.groups.monero = {
    gid = 991;
  };

  users.users.nix-serve = {
    isSystemUser = true;
    group = "nix-serve";
  };

  users.groups.nix-serve = { };
}
