{
  osConfig,
  ...
}:
{
  # systemd.user.squeezelite = {
  #   wantedBy = ["default.target"];
  # };

  home.stateVersion = osConfig.system.stateVersion;
  home.enableNixpkgsReleaseCheck = false;
}
