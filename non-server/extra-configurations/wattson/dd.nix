{ ... }: {
  virtualisation.virtualbox = {
    host.enable = true;
    guest = {
      enable = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "ole" ];
}
