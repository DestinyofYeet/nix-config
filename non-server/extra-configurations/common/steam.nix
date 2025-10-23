{ pkgs, ... }:
let gaming-pkgs = with pkgs; [ gamescope mangohud gamemode vkbasalt ];
in {

  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  programs.steam = {

    extraPackages = gaming-pkgs;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  environment.systemPackages = with pkgs;
    [

      goverlay
    ] ++ gaming-pkgs;
}
