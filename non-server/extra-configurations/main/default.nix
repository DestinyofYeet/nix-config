# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:
let
  gaming-pkgs = with pkgs; [
    gamescope
    mangohud
    amdvlk
    gamemode
    vkbasalt
  ];
in
{
  # nix.settings = {
  #     substituters = [
  #       "http://cache.nix-server.infra.wg:5000?priority=30"
  #     ];

  #     trusted-public-keys = [
  #       "cache.nix-server.infra.wg:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg="
  #     ];
  # };

  programs.steam = {
    extraPackages = gaming-pkgs;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

  # programs.immersed.enable = true;

  networking.extraHosts = ''
    192.168.0.250 nix-server.infra.wg
  '';

  # everything needed for beatsabermodmanager
  # nixpkgs.config.permittedInsecurePackages = [
  #   "dotnet-combined"
  #   "dotnet-wrapped-combined"
  #   "dotnet-runtime-wrapped-7.0.20"
  #   "dotnet-runtime-7.0.20"
  #   "dotnet-sdk-7.0.20"
  #   "dotnet-wrapped-sdk-7.0.20"
  #   "dotnet-sdk-wrapped-7.0.410"
  #   "dotnet-sdk-7.0.410"
  #   "dotnet-sdk-wrapped-6.0.428"
  #   "dotnet-sdk-6.0.428"
  # ];

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
    ]
    ++ gaming-pkgs;

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
      speedFactor = 1;
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

  # needed for SteamVR
  # boot.kernelPatches = [
  #   {
  #   name = "amdgpu-ignore-ctx-privileges";
  #   patch = pkgs.fetchpatch {
  #     name = "cap_sys_nice_begone.patch";
  #     url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
  #     hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
  #   };
  # }
  # ];

  boot.extraModulePackages = [
    (pkgs.callPackage ./amdgpu.nix {
      inherit (config.boot.kernelPackages) kernel;
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        })
      ];
    })
  ];

  programs.envision = {
    enable = false;
  };

  services.wivrn = {
    enable = false;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        # 1.0x foveation scaling
        scale = 1.0;
        # 100 Mb/s
        bitrate = 100000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "h265";
            # 1.0 x 1.0 scaling
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
      };
    };
  };
}
