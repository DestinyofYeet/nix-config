{ lib, pkgs, ... }: {
  programs.shell-aliases = {
    enable = true;
    aliases = {
      "ll" = {
        default = "ls -lah";

        nushell = "ls -la";
      };

      "rebuild-system" = {
        default = "sudo nixos-rebuild switch --flake /home/ole/nixos#";

        # nushell = "'sudo -v; sudo nixos-rebuild build --flake /home/ole/nixos# --log-format internal-json -v o+e>| nom --json'";
        nushell = null;
      };

      "test-system" = {
        default = "sudo nixos-rebuild test --flake /home/ole/nixos#";

        # nushell = "'sudo -v; sudo nixos-rebuild test --flake /home/ole/nixos#'";
        nushell = null;
      };

      "l" = "ls";

      "yz" = { default = "${pkgs.yazi}/bin/yazi"; };

      "lg" = { default = "${pkgs.lazygit}/bin/lazygit"; };

      "tt" = { default = "${pkgs.taskwarrior-tui}/bin/taskwarrior-tui"; };

      "kssh" = "kitten ssh";
      "icat" = "kitten icat";

      "generate-email-alias" = {
        default =
          "${lib.custom.scripts.generate-email-alias}/bin/generate-email-alias";

        # bash = null;
      };

      "fix-store" = "nix-store --verify --check-contents --repair";

      "wicat" = "wezterm imgcat";
      "wssh" = "wezterm ssh";
      "wconnect" = "wezterm connnect";
    };
  };
}
