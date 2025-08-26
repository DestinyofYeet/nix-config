{ config, ... }: {
  services.ssh-agent.enable = true;

  # programs.ssh.addKeysToAgent = true;

  # age.secrets = {
  #   ssh-github = {
  #     file = ../secrets/ssh-github-nixos.age;
  #   };
  # };

  # home.file = {
  #   "${config.home.homeDirectory}/.ssh/config" = {
  #     text = ''
  #       Host github.com
  #         Hostname github.com
  #         User git
  #         IdentityFile ${config.age.secrets.ssh-github.path}
  #     '';
  #   };
  # };
}
