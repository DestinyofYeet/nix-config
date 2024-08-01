{ pkgs, ... }: let 
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox.enable = true;

  programs.firefox.profiles.default-profile = {
    id = 0;
    name = "default-profile";
    isDefault = true;

    search.engines = {
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
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

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

        definedAliases = [ "@no" ];
      };
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
    ];

    settings = {
      "extensions.autoDisableScopes" = 0; # automatically enable plugins
    };
  };
}
