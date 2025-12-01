{ ... }: {
  services.beszel_agent = {
    enable = true;
    port = 45876;
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEynJeSmkCHA7bHfmbFZxZbP0W2vxcGp7Vi4EKp5x0TY";
    host = "172.27.255.1";
  };
}
