{
  pkgs,
  ...
}:
{
  security = {
    sudo.enable = true;
    doas.enable = true;
  };

  programs = {
    zsh.enable = true;
    fish.enable = true;
    starship.enable = true;
  };

  environment.systemPackages = with pkgs; [
    helix
    vim

    traceroute
    nmap

    python3
  ];
}
