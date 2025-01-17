let
  ole_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPS9Q4l5A3pr5DwW6737YRVLGgXxLif1ab8VKS9oeHk root@wattson";

  ole_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  authed = [
    ole_system
    ole_laptop
  ];

in
{
  "wireguard-vpn-priv-key.age".publicKeys = authed;
}
