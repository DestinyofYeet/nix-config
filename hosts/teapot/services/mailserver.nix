{
  pkgs,
  config,
  secretStore,
  custom,
  ...
}:
let
  secrets = secretStore.get-server-secrets "teapot";
in
{
  age.secrets = {
    ole-mail.file = secrets + "/ole-ole.blue.age";
    scripts-uwuwhatsthis-de.file = secrets + "/scripts-uwuwhatsthis.de.age";
    sonarr-uwuwhatsthis-de.file = secrets + "/sonarr-uwuwhatsthis.de.age";
    prowlarr-uwuwhatsthis-de.file = secrets + "/prowlarr-uwuwhatsthis.de.age";
    uptime-kuma-uwuwhatsthis-de.file = secrets + "/prowlarr-uwuwhatsthis.de.age";

    firefly-iii-ole-blue.file = secrets + "/firefly-email-credentials.age";
    zed-uwuwhatsthis-de.file = secrets + "/zed-uwuwhatsthis.de.age";

    nextcloud-uwuwhatsthis-de.file = secrets + "/nextcloud-uwuwhatsthis.de.age";
    nextcloud-ole-blue.file = secrets + "/nextcloud-ole-blue.age";

    forgejo-email-ole-blue.file = secretStore.secrets + "/servers/teapot/forgejo_email_password.age";

    authelia-email-ole-blue.file = secrets + "/authelia-hashed-email-password.age";

    dmarc-email-ole-blue.file = secrets + "/dmarc-hashed-email-password.age";

    msmtp-email-ole-blue.file = secrets + "/msmtp-ole-blue.age";

    rspamd-domain-whitelist = {
      file = secrets + "/rspamd-domain-whitelist.age";
      owner = config.services.rspamd.user;
      group = config.services.rspamd.group;
    };

    mastodon-email-ole-blue.file = secrets + "/mastodon_email_password_hash.age";

    authentik-email-ole-blue.file = secrets + "/authentik_email_password_hash.age";
  };

  mailserver = rec {
    enable = true;
    fqdn = "mail.ole.blue";

    # ~50MB
    messageSizeLimit = 51200000;

    x509.useACMEHost = "mail.ole.blue";

    stateVersion = 3;

    useUTF8FolderNames = true;

    systemDomain = "ole.blue";
    systemName = "ole";

    dmarcReporting = {
      enable = true;
      excludeDomains = [
        "jyo333.com"
        "uwbswd.com"
        "csxkg.net"
        "hb-fec.net"
      ];
    };

    domains = [
      "ole.blue"
      "uwuwhatsthis.de"
      "drogen.gratis"
      #"strichliste.rs"
    ];

    fullTextSearch = {
      enable = true;
      autoIndex = true;
      enforced = "body";
    };

    enableManageSieve = true;

    monitoring = {
      enable = true;
      alertAddress = "ole@ole.blue";
    };

    # somehow nukes my nameserver entries in /etc/resolv.conf and no more ns lookups are possible
    localDnsResolver = false;

    # forwards = { "security@strichliste.rs" = [ "ole@strichliste.rs" ]; };

    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "ole@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.ole-mail.path}";

        sieveScript = ''
          require ["fileinto"];

          if address "From" "scripts@uwuwhatsthis.de" {
            fileinto "INBOX.scripts";
          } elsif address "From" "sonarr@ole.blue" {
            fileinto "INBOX.sonarr";
          } elsif address "From" "prowlarr@uwuwhatsthis.de" {
            fileinto "INBOX.prowlarr";
          }

          if anyof (
            header :contains "to" "postmaster@ole.blue",
            header :contains "to" "postmaster@uwuwhatsthis.de"
          ) {
            fileinto "INBOX.postmaster";
          } elsif anyof (
            header :contains "to" "abuse@ole.blue",
            header :contains "to" "abuse@uwuwhatsthis.de"
          ){
            fileinto  "INBOX.abuse";
          }
        '';

        aliases = map (domain: "@${domain}") domains;
      };

      "scripts@uwuwhatsthis.de" = {
        hashedPasswordFile = "${config.age.secrets.scripts-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "sonarr@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.sonarr-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "prowlarr@uwuwhatsthis.de" = {
        hashedPasswordFile = "${config.age.secrets.prowlarr-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "uptime-kuma@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.uptime-kuma-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "firefly-iii@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.firefly-iii-ole-blue.path}";
        sendOnly = true;
      };

      "zed@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.zed-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "nextcloud@uwuwhatsthis.de" = {
        hashedPasswordFile = "${config.age.secrets.nextcloud-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "nextcloud@ole.blue" = {
        hashedPasswordFile = config.age.secrets.nextcloud-ole-blue.path;
        sendOnly = true;
      };

      "forgejo@ole.blue" = {
        hashedPasswordFile = config.age.secrets.forgejo-email-ole-blue.path;
      };

      "auth@ole.blue" = {
        hashedPasswordFile = config.age.secrets.authelia-email-ole-blue.path;
      };

      "dmarc@ole.blue" = {
        hashedPasswordFile = config.age.secrets.dmarc-email-ole-blue.path;
        aliases = [
          "dmarc@uwuwhatsthis.de"
          "noreply-dmarc@ole.blue"
        ];
      };

      "msmtp@ole.blue" = {
        hashedPasswordFile = config.age.secrets.msmtp-email-ole-blue.path;
        aliases = [ "smartd@ole.blue" ];
      };

      "mastodon@drogen.gratis" = {
        sendOnly = true;
        hashedPasswordFile = config.age.secrets.mastodon-email-ole-blue.path;
      };

      "authentik@ole.blue" = {
        sendOnly = true;
        hashedPasswordFile = config.age.secrets.authentik-email-ole-blue.path;
        aliases = [ "authentik@ole.blue" ];
      };
    };
  };

  services.roundcube = {
    enable = true;

    dicts = with pkgs.aspellDicts; [
      en
      de
    ];

    plugins = [
      # "managesieve"
      # "virtuser_file"
    ];

    hostName = "mail.ole.blue";
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}:993";

      $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_port'] = '4190';
      $config['managesieve_host'] = '127.0.0.1';
      $config['managesieve_auth_type'] = 'PLAIN';
      $config['managesieve_usetls'] = false;

    '';
    # $config['virtuser_file'] = "${virtuser_file}";

    configureNginx = true;
  };

  services.rspamd =
    let
      weight_failed = "10000";
    in
    {
      locals = {
        "multimap.conf".text = ''
          # yoinked from https://serverfault.com/questions/1124017/rspamd-whitelis-blacklist-per-domain-before-filtering
          WHITELIST_SENDER_DOMAIN {
                  # See: https://rspamd.com/doc/modules/multimap.html#email-related-types
                  type = "from";
                  # See: https://rspamd.com/doc/modules/multimap.html#from-rcpt-and-header-filters
                  filter = "email:domain";
                  map = "${config.age.secrets.rspamd-domain-whitelist.path}";
                  symbol = "WHITELIST_SENDER_DOMAIN";
                  description = "Manual whitelist for specific domains";
                  # See: https://rspamd.com/doc/modules/multimap.html#pre-filter-maps
                  action = "accept";
          }
        '';

        "milter_headers.conf".text = ''
          extended_spam_headers = true;
        '';

        # "options.inc".text = ''
        #   gtube_patterns = "all";
        # '';

        "groups.conf".text =
          let
            mkFailedSingle = symbol: ''"${symbol}" { weight = ${weight_failed}; }'';
            mkFailed =
              listOfSymbols: (builtins.concatStringsSep "\n" (map (symbol: mkFailedSingle symbol) listOfSymbols));
          in
          ''

            symbols {
              "DMARC_POLICY_REJECT" { weight = ${weight_failed}; }
              "DMARC_POLICY_SOFTFAIL" { weight = ${weight_failed}; }

              # matches hashed bad message
              "FUZZY_DENIED" { weight = 10; }

              ${mkFailed [
                "DMARC_NA" # has no dmarc
                "R_DKIM_NA" # has no dkim
                "R_SPF_FAIL" # sfp verification failed
                "RBL_MAILSPIKE_WORST" # worst possible spam reputation
                "RBL_VIRUSFREE_BOTNET" # from address is listed in botnet
                "RBL_SEM" # From address is listed in Spameatingmonkey RBL
              ]}
            }
          '';
      };
      extraConfig = ''
        actions {
          reject = null;
          add_header = 15;
          greylist = null;
        }
      '';

      workers.controller.extraConfig = ''
        secure_ip = [ "${custom.nebula.yeet.hosts.teapot.ip}" ];
        enable_password = "$2$37qhz69pbjmqtoqjrthocz5gkxin5h8a$xwps8cs7hhsrx1ydj85acy9ctxmp1achw8hu6zq6qbe88kj9qery";
      '';
    };

  systemd.services.nginx.serviceConfig.protectHome = false;
  users.groups.nginx.members = [ config.services.rspamd.user ];

  services.nginx.virtualHosts."rspamd.mail.ole.blue" = {
    listenAddresses = [ custom.nebula.yeet.hosts.teapot.ip ];
    locations."/".proxyPass = "http://unix:/run/rspamd/worker-controller.sock";
  };
}
