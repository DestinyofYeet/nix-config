{ ... }: {
  home.stateVersion = "24.05";

  # needed for agenix service to start properly
  systemd.user.startServices = "sd-switch";


  imports = [
    ./btop.nix
    ./bash.nix
    ./ssh.nix
    ./agenix.nix
  ];
}
