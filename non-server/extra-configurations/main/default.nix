# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:
{

  imports = [
    ./steam.nix
    ./vr.nix
    ./vpn.nix
    ./agenix.nix
  ];

  networking.extraHosts = ''
    192.168.0.250 nix-server.infra.wg
  '';
  services.flatpak.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      vulkan-tools
      goverlay
      sidequest
      # beatsabermodmanager
      protonup-qt
      glslang
      gst_all_1.gstreamer
      # Common plugins like "filesrc" to combine within e.g. gst-launch
      gst_all_1.gst-plugins-base
      # Specialized plugins separated by quality
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      # Plugins to reuse ffmpeg to play almost every video format
      gst_all_1.gst-libav
      # Support the Video Audio (Hardware) Acceleration API
      gst_all_1.gst-vaapi
      libdrm
    ];
  
  services.postgresql = {
    enable = false;
    ensureDatabases = [ "strichliste-rs" ];

    ensureUsers = [
      {
        name = "strichliste-rs";
        ensureDBOwnership = true;
      }
    ];
  };

  nix.buildMachines = [
    {
      hostName = "teapot";
      system = "x86_64-linux";
      protocol = "ssh";
      maxJobs = 4;
      speedFactor = 0;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.distributedBuilds = true;

  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

}
