{pkgs, ...}: {
  programs.helix = {
    enable = true;

    defaultEditor = true;

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
        }
      ];

      language-server = {
        nil = {
          config.nil = {
            formatting.command = ["${pkgs.alejandra}/bin/alejandra" "-q"];

            nix = {
              maxMemoryMB = 10000;
              flake = {
                autoArchive = true;
                autoEvalInputs = false;
              };
            };
          };
        };
      };
    };

    settings = {
      theme = "material_deep_ocean";

      editor = {
        mouse = false;
      };
    };
  };
}
