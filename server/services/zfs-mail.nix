{
  pkgs,
  config,
  ...
}: let
  aliases-file = pkgs.writeText "aliases" ''
    root: ole@uwuwhatsthis.de
  '';
in {
  age.secrets = {
    zed-email-credentials = { file = ../secrets/zed-email-credentials.age; };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    zfsStable = pkgs.zfsStable.override { enableMail = true; }; # Recompile ZFS with mail Capabilities
  };

  programs.msmtp = {
    setSendmail = true;
    defaults = {
      aliases = aliases-file;
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "off";
    };

    accounts = {
      default = {
        host = "mx.uwuwhatsthis.de";
        passwordeval = "cat ${config.age.secrets.zed-email-credentials}";
        user = "zed@uwuwhatsthis.de";
        from = "zed@uwuwhatsthis.de";
      };
    };
  };

  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };

  services.zfs.zed.enableMail = true;
}
