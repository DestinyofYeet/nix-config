{ ... }: {
  systems.stateVersion = "26.05";
  networking = {
    hostname = "hope";
    networkmanager.enable = true;
  };

  console.keyMap = "de";
}
