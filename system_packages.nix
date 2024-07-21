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
        dig
        gawk
        gnugrep
        gnused
        coreutils
        nmap
        file
      ];

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "surrealdb"
      "elasticsearch"
    ];

	environment.variables = { EDITOR = "vim"; };
}
