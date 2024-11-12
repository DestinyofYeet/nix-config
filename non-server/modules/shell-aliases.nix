{
  ...
}:{
  programs.shell-aliases = {
    enable = true;
    aliases = {
      "ll" = {
        default = "ls -lah";

        nushell = "ls -la";
      };

      "rebuild-system" = "sudo nixos-rebuild switch --flake /home/ole/nixos#";
      "test-system" = "sudo nixos-rebuild test --flake /home/ole/nixos#";

      "l" = "ls";

      "yz" = "yazi";
      "lg" = "lazygit";

      "kssh" = "kitten ssh";
      "icat" = "kitten icat";
    };
  };

  programs.fish.enable = true;
}
