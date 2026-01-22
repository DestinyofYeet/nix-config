rec {
  users = {
    wattson =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";
    main =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";
    kartoffelkiste =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2jyQTUDWYpICbxVXL8RMt1ZemWQKf6wy/4jNnd6EmP ole@kartoffelkiste";
  };

  hosts = {
    wattson.hostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPS9Q4l5A3pr5DwW6737YRVLGgXxLif1ab8VKS9oeHk root@wattson";
    main.hostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZtz6IoSoBQVGLSRoKdPWrEr7AJ9rTCTnra1WAtqxG/ root@main";
    kartoffelkiste.hostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAH1uF5xWfXv0rdeY38r2ORiYWMIK74jT4DwMj5Svjs root@kartoffelkiste";

    nix-server = {
      users.root.key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAzr6fAow9E19rsmJdMXA3kJvhzPPCmnH5hD2UhuufEq root@nixos";
      hostKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";
      vms = {
        forgejo-runner.hostKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYt/UwSc/96eqfzbd4nqbNsAfqfNXSlPClK7Wd6trT1";
        ha-vm.hostKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYfIB3qskyNnmxPlFx6TuzyEn5IEgdgBEwVOFhlH+OC";
      };
    };
    teapot = {
      users.root.key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdiLELKdn6dLl3UMqmHpf4HvKPQYbPYwlaKLT5mVNQi root@teapot";
      hostKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqmDnGXPNc+Z1DRHVRRqik2WpeGjVoSOdKi1baXafH root@teapot";

      vms = {
        ha-vm = {
          hostKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIQofo0QZ4F0jkoKa6n8ZANpbbZsQqzZ9V7GdYqXbvI";
        };
      };
    };
    bonk = {
      hostKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDH4DwddDZwmIIDsP5kO+FkcrfMKPc9KbAzet5jxhmy root@bonk";

      users.root.key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMOvcDuphI+Wa9Dst7QraflSgHEIHMeeDfP6q6bUNcN root@bonk";

      vms = {
        ha-vm = {
          hostKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFE0/4heAMyEufC834RBhlKHIxG1dr/t9LiHpdC2ZtDA";
        };
      };
    };
    nixie.hostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInWaeHa3NaK6z9FIwFDCmWE8ofAlRl9K/k9YJ3lgq7p root@nixos";
  };

  authed = with users; [ wattson main kartoffelkiste ];
}
