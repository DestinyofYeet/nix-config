{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  generate-email-alias = pkgs.writers.writePython3Bin "generate-email-alias" {
    flakeIgnore = [
      "W291"
      "E305"
      "E501"
      "E111"
      "E302"
    ];
  } ./create-email-alias.py;
}
