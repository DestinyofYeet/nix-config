{ pkgs, lib, ... }:
let
  modprobe = lib.getExe' pkgs.kmod "modprobe";
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "fix-trackpad" ''
      sudo -v
      sudo ${modprobe} -r i2c_hid_acpi
      sudo ${modprobe} i2c_hid_acpi
    '')
  ];
}
