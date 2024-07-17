{ config, pkgs, lib, modulesPath, ... }:

{
    users.users.ole = {
    	isNormalUser = true;
    	home = "/home/ole";
    	description = "me";
    	extraGroups = [ "wheel" "docker" ];
    	hashedPassword = "$6$s5ZWf9efO2lEySC0$ztuOgJsHnckwmcP5EEpgcDJeUpJD3ZJuynRIuuC.IEBLMBtkZS5R1JQ7c4a/oUU6Tp8eDWNUoHjckyL/hivvg1";
    	openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+VUI7U1fv0W6Lp40Jss9yA6JX+JG/Hocroff6HtlFT ole@kartoffelkiste" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhLrbWc/gopTJ2ZZW4ZfCzGhjhV9fKb1wdvFLQpmP3y ole@main" ];
    		packages = with pkgs; [
    			neovim
    		];
          };
    users.users.apps = {
      isSystemUser = true;
      uid = 568;
      group = "apps";
    };

    users.groups.apps = {
      gid = 568;
    };
}
