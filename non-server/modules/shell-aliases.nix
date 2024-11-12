{
  ...
}:{
  programs.shell-aliases = {
    enable = true;
    aliases = {
      "ll" = {
        default = "ls -lah";

        nushell = "ls -la";
        bash = null;
      };

      "lg" = "lazygit";

      "rebuild-system" = "sudo nixos-rebuild switch --flake /home/ole/nixos#";
    };
  };
}
