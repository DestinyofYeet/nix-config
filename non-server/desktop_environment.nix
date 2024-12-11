{ pkgs, ... }: 

let
sddm-theme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = pkgs.fetchFromGitHub {
        owner = "gpskwlkr";
        repo = "sddm-astronaut-theme";
        rev = "468a100460d5feaa701c2215c737b55789cba0fc";
        sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
    };
    installPhase = ''
        mkdir -p $out
        cp -R ./* $out/
    '';
};

in {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    # theme = "${sddm-theme}";

    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = [(
    pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      #font  = "Noto Sans";
      #fontSize = "9";
      background = "${../images/forest.png}";
      loginBackground = true;
    }
  )];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # disable automatically changing of bluetooth codecs
    # wireplumber.extraConfig."11-bluetooth-policy" = {
    #   "wireplumber.settings" = {
    #     "bluetooth.autoswitch-to-headset-profile" = false;
    #   };
    # };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # make window decorations work properly
  programs.dconf.enable = true;

  # disable mouse accel
  services.libinput.mouse.accelProfile = "flat";
}
