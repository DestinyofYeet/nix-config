{ ... }: {
  services.openssh = { enable = true; };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6ZvR6O8gEGZAAVIU5m4AE4S0YTxa2BOPv9g5gUZ6wV ole@main"
  ];
}
