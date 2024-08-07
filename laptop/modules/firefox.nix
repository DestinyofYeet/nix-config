{ pkgs, ... }: let 
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox.enable = true;

  programs.firefox.profiles.default-profile = {
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
              { name = "channel"; value = "24.05"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = ../../images/nix-logo.png;

          definedAliases = [ "@no" ];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.hidden = true;
        "DuckDuckGo".metaData.hidden = true;
      };
    };

    containersForce = true;

    #containers = {
    #  personal = {
    #    color = "blue";
    #    id = 0;
    #    icon = "fingerprint";
    #  };
    #};

    settings = {
      "privacy.resistFingerprinting" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.startup.homepage" = "about:blank";
      "browser.newtabpage.enabled" = false;
      "trailhead.firstrun.didSeeAboutWelcome" = true;
      "app.shield.optoutstudies.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "signon.rememberSignons" = false;
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
    ];

    settings = {
      "extensions.autoDisableScopes" = 0; # automatically enable plugins
    };
  };
}
