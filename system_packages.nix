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
        bat
        netdata
        libcgroup
        wireguard-tools
        iproute2
        qbittorrent-nox
        nettools
        python3
        iptables
  	];

	environment.variables = { EDITOR = "vim"; };
}
