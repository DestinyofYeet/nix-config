# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./packages.nix
    ./desktop_environment.nix
    ./system_users.nix
    ./services.nix
    ./scripts
    ./yubikey.nix
    ./background.nix
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de";
  # services.xserver.xkb.layout = "de";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # use lib.mkForce to only use these substituters
    substituters = [ "https://cache.ole.blue?priority=20" ];

    trusted-public-keys =
      [ "cache.ole.blue:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg=" ];
    trusted-users = [ "ole" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # environment.etc."current-system-packages".text =
  #   let
  #     packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
  #     sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
  #     formatted = builtins.concatStringsSep "\n" sortedUnique;
  #   in
  #   formatted;

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  hardware.keyboard.zsa.enable = true;

  # hardware.graphics.extraPackages = with pkgs.rocmPackages; [
  # rocm-runtime
  # rocm-smi
  # ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = lib.mkDefault (with pkgs; [
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ]);

    config.common.default = "*";
  };

  services.displayManager.sddm = {
    enable = true;
    # catppuccin-mocha is a qt6 theme
    package = lib.mkDefault pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha";
    # theme = "${sddm-theme}";

    wayland.enable = true;
  };

  services.udisks2 = { enable = true; };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      #font  = "Noto Sans";
      #fontSize = "9";
      background = "${../images/forest.png}";
      loginBackground = true;
    })
  ];

  # programs.command-not-found.enable = false;

  # programs.nix-index = {
  #   enable = true;
  # };
  #
  #
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.libinput.enable = true;
}
