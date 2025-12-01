{ pkgs, ... }: { environment.systemPackages = with pkgs; [ zfs hdparm ]; }
