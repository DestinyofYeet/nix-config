let
  ole_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPS9Q4l5A3pr5DwW6737YRVLGgXxLif1ab8VKS9oeHk root@wattson";

  authed = [ ole_system ];

in
{
  "wireguard-vpn-priv-key.age".publicKeys = authed;
}
