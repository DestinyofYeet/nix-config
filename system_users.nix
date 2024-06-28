{ config, pkgs, lib, modulesPath, ... }:

{

users.users.ole = {
	isNormalUser = true;
	home = "/home/ole";
	description = "me";
	extraGroups = [ "wheel" ];
	openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+VUI7U1fv0W6Lp40Jss9yA6JX+JG/Hocroff6HtlFT ole@kartoffelkiste" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhLrbWc/gopTJ2ZZW4ZfCzGhjhV9fKb1wdvFLQpmP3y ole@main" ];
		packages = with pkgs; [
			neovim
		];
	};
}
