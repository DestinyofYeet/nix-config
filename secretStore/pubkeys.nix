rec {
  users = {
    wattson =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";
    main =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";
    kartoffelkiste =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2jyQTUDWYpICbxVXL8RMt1ZemWQKf6wy/4jNnd6EmP ole@kartoffelkiste";
  };
  systems = {
    wattson =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPS9Q4l5A3pr5DwW6737YRVLGgXxLif1ab8VKS9oeHk root@wattson";
    main =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZtz6IoSoBQVGLSRoKdPWrEr7AJ9rTCTnra1WAtqxG/ root@main";
    kartoffelkiste =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAH1uF5xWfXv0rdeY38r2ORiYWMIK74jT4DwMj5Svjs root@kartoffelkiste";

    nix-server =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";
    teapot =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqmDnGXPNc+Z1DRHVRRqik2WpeGjVoSOdKi1baXafH root@teapot";
    bonk =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDH4DwddDZwmIIDsP5kO+FkcrfMKPc9KbAzet5jxhmy root@bonk";
  };

  root = {
    nix-server =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAzr6fAow9E19rsmJdMXA3kJvhzPPCmnH5hD2UhuufEq root@nixos";
  };

  authed = with users; [ wattson main kartoffelkiste ];
}
