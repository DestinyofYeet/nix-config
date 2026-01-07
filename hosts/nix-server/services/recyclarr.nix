{ secretStore, config, ... }:
let
  mkTemplates = templates: map (input: { "template" = input; }) templates;
  mkAssignedProfiles = name: score: [{
    name = name;
    score = score;
  }];

  secrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = let
    ownership = {

      owner = config.services.recyclarr.user;
      group = config.services.recyclarr.group;
    };
  in {
    sonarrApiKey = {
      file = secrets + "/recyclarr-sonarr-token.age";
    } // ownership;
    radarrApiKey = {
      file = secrets + "/recyclarr-radarr-token.age";
    } // ownership;
  };

  services.recyclarr = {
    enable = true;
    configuration = {
      sonarr = {
        main_sonarr = {
          api_key = { _secret = config.age.secrets.sonarrApiKey.path; };

          base_url = "https://sonarr.local.ole.blue";

          include = (mkTemplates [
            "sonarr-quality-definition-anime"
            "sonarr-v4-quality-profile-anime"
            "sonarr-v4-custom-formats-anime"
          ]);

          # Custom Formats: https://recyclarr.dev/reference/configuration/custom-formats/
          custom_formats = let
            mkSonarrAssignedProfiles =
              (mkAssignedProfiles "Remux-1080p - Anime");

          in [
            {
              trash_ids = [
                "026d5aadd1a6b4e550b134cb6c72b3ca" # Uncensored
              ];

              assign_scores_to = (mkSonarrAssignedProfiles 0);
            }
            {
              trash_ids = [
                "b2550eb333d27b75833e25b8c2557b38" # 10 bit
              ];

              assign_scores_to = (mkSonarrAssignedProfiles 0);
            }

            {
              trash_ids = [
                "418f50b10f1907201b6cfdf881f467b7" # Anime dual Audio
              ];

              assign_scores_to = (mkSonarrAssignedProfiles 0);
            }

          ];
        };
      };

      radarr = {
        main_radarr = {
          base_url = "https://radarr.local.ole.blue";
          api_key = { _secret = config.age.secrets.radarrApiKey.path; };

          include = (mkTemplates [
            "radarr-quality-definition-anime"
            "radarr-quality-profile-anime"
            "radarr-custom-formats-anime"
          ]);

          custom_formats = let
            mkRadarrAssignedProfiles =
              (mkAssignedProfiles "Remux-1080p - Anime");
          in [
            {
              trash_ids = [
                "064af5f084a0a24458cc8ecd3220f93f" # Uncensored
              ];

              assign_scores_to = (mkRadarrAssignedProfiles 0);
            }

            {
              trash_ids = [
                "a5d148168c4506b55cf53984107c396e" # 10bit
              ];

              assign_scores_to = (mkRadarrAssignedProfiles 0);
            }
            {
              trash_ids = [
                "4a3b087eea2ce012fcc1ce319259a3be" # Anime dual Audio
              ];

              assign_scores_to = (mkRadarrAssignedProfiles 0);
            }
          ];
        };
      };
    };
  };
}
