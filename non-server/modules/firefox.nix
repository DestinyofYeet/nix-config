{ pkgs, lib, ... }: let 
  addons = pkgs.nur.repos.rycee.firefox-addons;

  build-containers = container-list : lib.mkMerge (lib.imap1 (i: v: builtins.mapAttrs (name: value: {
      color = value.color or "toolbar";
      icon = value.icon or "circle";
      id = i;
    }) v) container-list);

in {
  programs.firefox.enable = true;

  home.sessionVariables = {
    # enable wayland for firefox
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs.firefox.profiles = {
    blank = {
      id = 1;
      name = "Blank profile";
    };

    default-profile = {
      id = 0;
      name = "default-profile";
      isDefault = true;

      search = {
        force = true;

        engines = {
          "Startpage" = {
            urls = [{
              template = "https://www.startpage.com/sp/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }];
          };

          "Home-manager Option" = {
            urls = [{
              template = "https://home-manager-options.extranix.com";
              params = [
                { name = "release"; value = "release-24.05"; }
                { name = "channel"; value = "unstable"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            definedAliases = [ "@hmo" ];
          };

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "channel"; value = "unstable"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = ../../images/nix-logo.png;

            definedAliases = [ "@np" ];
          };

          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "channel"; value = "unstable"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = ../../images/nix-logo.png;

            definedAliases = [ "@no" ];
          };

          "Nix manual search" = {
            urls = [
              {
                template = "https://noogle.dev/";
                params = [{
                  name = "term";
                  value = "{searchTerms}";
                }];              
              }
            ];

            definedAliases = [ "@nms" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
        };
      };

      containersForce = true;

      # containers = {
      #   dummy = {
      #     color = "toolbar";
      #     id = 0;
      #     icon = "circle";
      #   };
      #   google = {
      #     color = "red";
      #     id = 1;
      #     icon = "circle";
      #   };
      #   oth = {
      #     color = "turquoise";
      #     id = 2;
      #     icon = "circle";
      #   };
      #   ai = {
      #     color = "red";
      #     id = 3;
      #     icon = "circle";
      #   };
      # };

      containers = build-containers [
        {
          google = {
            color = "red";
          };
        }
        {
          oth = {
            color = "turquoise";
          };
        }
        {
          ai = {
            color = "red";
          };
        }
        {
          amazon = {
            icon = "cart";
            color = "purple";
          };
        }
        {
          coding = {
            color = "blue";
          };
        }
        {
          vps = {
            color = "blue";
          };
        }
        {
          personal = {
            color = "blue";
            icon = "fingerprint";
          };
        }
        {
          reddit = {
            color = "red";
          };
        }
      ];

      settings = {
        "privacy.resistFingerprinting" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "extensions.formautofill.creditCards.enabled" = false;
        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.fixup.domainsuffixwhitelist.wg" = true; # make nix-server.infra.wg not result in a search

        # telemetry
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Studies
      	"app.shield.optoutstudies.enabled" = false;
      	"app.normandy.enabled" = false;
      	"app.normandy.api_url" = "";

        "browser.contentblocking.category" = "strict";
      };

      search.default = "Startpage";

      extensions = with addons; [
        darkreader
        ublock-origin
        bitwarden
        consent-o-matic
        sponsorblock
        dearrow
        vimium
        clearurls
        decentraleyes
        canvasblocker
        don-t-fuck-with-paste
        return-youtube-dislikes
        single-file
        temporary-containers
        facebook-container
        multi-account-containers
        enhancer-for-youtube
        skip-redirect
        keepassxc-browser
        tree-style-tab
      ];

      settings = {
        "extensions.autoDisableScopes" = 0; # automatically enable plugins
      };

      userChrome = ''

        /* hides the native tabs */
        #TabsToolbar {
          visibility: collapse !important;
        }     

      '';
    };
  };
}
