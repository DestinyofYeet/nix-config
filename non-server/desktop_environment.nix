{ pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  services.libinput.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # disable mouse accel
  services.libinput.mouse.accelProfile = "flat";
}
