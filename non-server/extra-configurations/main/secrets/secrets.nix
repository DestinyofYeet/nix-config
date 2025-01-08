let
  ole_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZtz6IoSoBQVGLSRoKdPWrEr7AJ9rTCTnra1WAtqxG/ root@main";

  authed = [ ole_system ];

in
{
  "wireguard-vpn-priv-key.age".publicKeys = authed;
}
