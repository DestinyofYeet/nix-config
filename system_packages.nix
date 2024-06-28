{ config, pkgs, lib, modulesPath, ... }:

{
	environment.systemPackages = with pkgs; [
		btop
		vim
		man
		openssh
		innernet
		git
		gh
		matrix-conduit
		nginx
  ];
}
