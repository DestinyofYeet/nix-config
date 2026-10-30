{
  pkgs,
  config,
  lib,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages =
    with pkgs;
    [
      vim
      wget
      btop
      bat
      git
      unzip
      file
      helix
      dig
      iperf
      unixtools.netstat
      net-tools
      nmap
      tcpdump
    ]
    ++ (lib.optionals (!config.capabilities.storage.lowAmount) [
      zsh
      dmidecode
      wezterm
      smartmontools
      radeontop
      deploy-rs
      lshw
      pciutils
      amdgpu_top
      ripgrep
      fzf
      autoconf
      automake
      gcc
      gnumake
      nix-output-monitor
      wireguard-tools
      openssl
      ffmpeg
    ]);
}
