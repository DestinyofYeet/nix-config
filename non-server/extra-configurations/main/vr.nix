{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [ opencomposite wayvr ];

  programs.alvr = {
    enable = true;
    openFirewall = true;
  };

  programs.envision = { enable = false; };

  services.wivrn = {
    enable = false;
    openFirewall = true;

    # package = pkgs.wivrn.overrideAttrs {
    #   src = pkgs.fetchFromGitHub {
    #     owner = "wivrn";
    #     repo = "wivrn";
    #     rev = "v0.21.1";
    #     hash = "sha256-03KFVXD7/OTJi3sOHzTjYGLu5voUiz9YNqfO07rB7t4=";
    #   };
    # };

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
        bitrate = 120000000;
        encoders = [{
          # encoder = "vaapi";
          # codec = "h265";
          encoder = "x264";
          codec = "h265";
          # 1.0 x 1.0 scaling
          width = 1.0;
          height = 1.0;
          offset_x = 0.0;
          offset_y = 0.0;
        }];
      };
    };
  };

  boot.extraModulePackages = [
    (pkgs.callPackage ./amdgpu.nix {
      inherit (config.boot.kernelPackages) kernel;
      patches = [
        (pkgs.fetchpatch {
          url =
            "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        })
      ];
    })
  ];
}
